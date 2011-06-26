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

## Design considerations
### Using sendmail/postfix to send confirmation email
This application relies on a local Sendmail or Postfix server to deliver emails.
The alternative would have been to use ActiveMailer.

Pros:

* faster, everything is done locally, all network IO is done asynchronously
by the Postfix server after the messages are queued
* simple

Cons:

* less portable
* little information is returned to the caller about the result of the operation.

### Authentication
