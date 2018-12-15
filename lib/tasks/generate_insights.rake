desc "generates insights about a user"
task :generate_insights => :environment do
  user = User.where(last_insight_at: nil)&.first || User.order(:last_insight_at).first

  locations = user.get_locations_last_7_days

  if locations && user.places
    places_visited = []
    previous_place = nil
    current_visit  = {}

    locations.each_with_index do |location, idx|
      closest_place = user.places.by_distance(:origin => [location['lat'], location['lon']]).first
      distance = closest_place.distance_from(Geokit::LatLng.new(location['lat'], location['lon'])) * 1000
      current_place = (closest_place if distance <= closest_place.distance)

      # I'll improve this state machine logic when I've had some sleep
      if !current_place.nil? && previous_place.nil?
        current_visit[:arrived_at] = Time.parse(location['timestamp']).in_time_zone(user.time_zone)
        current_visit[:place] = current_place.name
      elsif (current_place.nil? && !previous_place.nil?) || ((idx + 1) == locations.count)
        current_visit[:departed_at] = Time.parse(location['timestamp']).in_time_zone(user.time_zone)
        current_visit[:duration] = current_visit[:departed_at] - current_visit[:arrived_at]
        places_visited.append(current_visit)
        current_visit = {}
      elsif current_place != previous_place && !current_place.nil?
        current_visit[:departed_at] = Time.parse(location['timestamp']).in_time_zone(user.time_zone)
        current_visit[:duration] = current_visit[:departed_at] - current_visit[:arrived_at]
        places_visited.append(current_visit)
        current_visit = {}
        current_visit[:arrived_at] = Time.parse(location['timestamp']).in_time_zone(user.time_zone)
        current_visit[:place] = current_place.name
      end

      previous_place = current_place
    end

    dates = (places_visited.first[:arrived_at].to_date..places_visited.last[:departed_at].to_date).map(&:to_s)
    places = user.places.map {|place| place.name}
    daily_stats = Hash[places.map {|place| [place, Hash[dates.map {|date| [date, 0]}]]}]

    places_visited.each do |visit|
      if visit[:arrived_at].to_date == visit[:departed_at].to_date
        daily_stats[visit[:place]][visit[:arrived_at].to_date.to_s] += visit[:duration] / 3600
      else
        daily_stats[visit[:place]][visit[:arrived_at].to_date.to_s] += (86400 - visit[:arrived_at].seconds_since_midnight) / 3600
        daily_stats[visit[:place]][visit[:departed_at].to_date.to_s] += (visit[:departed_at].seconds_since_midnight) / 3600
        (visit[:arrived_at].to_date..visit[:departed_at].to_date).map(&:to_s)[1..-2].each do |additional_dates|
          daily_stats[visit[:place]][additional_dates] = 24
        end
      end
    end

    daily_stats.each do |place, dates|
      dates.each do |date, hours|
        daily_stats[place][date] = daily_stats[place][date].round(2)
      end
    end

    series = daily_stats.map {|place, dates| "{label: \"#{place}\", data: #{dates.values.as_json}}"}.join

    query = """
      mutation {
        CreateInsight(
          source: \"Geo Insights\"
          chart: {
            title: \"Time Spent in places\"
            type: line
            category_axis: #{dates.as_json}
            series: [#{series}]
          }
        )
        {
          id
        }
      }
    """
    puts query
    response =  Memair.new(user.memair_access_token).query(query)
    puts response
  end
end
