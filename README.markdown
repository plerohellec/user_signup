# User Signup

## Dependencies
### System
This application has been setup and tested onUbuntu 11.04
with RVM ruby 1.9.2.
System package dependencies:
* libmysqlclient-dev
### Gems
* mysql2
* rspec-rails
* factory-girl-rails
* webrat
Run 'bundle install' to set them all up.

## Setup

### Mysql User
```
grant all privileges on user_signup_dev.* to 'yammer'@'localhost' identified by 'yammer';
grant all privileges on user_signup_test.* to 'yammer'@'localhost' identified by 'yammer';
```

### Database
From the shell:
```
rake db:create:all
rake db:migrate
```