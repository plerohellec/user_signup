# User Signup

## Dependencies
### System
This application has been setup and tested on Ubuntu 11.04
with RVM ruby 1.9.2.

System package dependencies:

* libmysqlclient-dev
### Gems
* mysql2
* rspec-rails
* factory-girl-rails
* webrat
* authlogic

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

## Configuration
The application configuration file is at config/initializers/app_config.rb.

The HOSTNAME config parameter MUST be updated for your environment. It's the hostname that will appear in the URL in the confirmation email.

## Design considerations
### Using sendmail/postfix to send confirmation email
The ActiveMailer configuration relies on a local Sendmail or Postfix server to deliver emails.

Pros:

* faster, everything is done locally, all network IO is done asynchronously
by the Postfix server after the messages are queued

Cons:

* less portable
* little information is returned to the caller about the result of the operation.

### Authentication
Using Authlogic gem for password and session management.

## Tests
Using rspec.
More work would be needed on those tests.

To run the tests

```
rake spec
```

