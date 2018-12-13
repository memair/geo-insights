desc "generates insights about a user"
task :generate_insights => :environment do
  user = User.where(last_insight_at: nil)&.first || User.order(:last_insight_at).first

end
