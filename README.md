# README

## DB setup

### Dev

```
CREATE DATABASE geo_insights_development;
CREATE USER geo_insights_development WITH PASSWORD 'password';
ALTER USER geo_insights_development WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE "geo_insights_development" to geo_insights_development;
```

### Test

```
CREATE DATABASE geo_insights_test;
CREATE USER geo_insights_test WITH PASSWORD 'password';
ALTER USER geo_insights_test WITH SUPERUSER;
GRANT ALL PRIVILEGES ON DATABASE "geo_insights_test" to geo_insights_test;
```

### db restarting

```
bundle exec rake db:drop RAILS_ENV=development
bundle exec rake db:create RAILS_ENV=development
bundle exec rake db:migrate RAILS_ENV=development
```