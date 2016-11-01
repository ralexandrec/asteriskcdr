### Asterisk Cdr Ruby - Asterisk Call Data Records Report in Ruby
---
Simple asterisk call data records in ruby, sinatra and angularJs

VERSION 1.0

###Initial setup:
Copy and change these files:

cp config/config.sample.yml config/config.yml

cp config/database.sample.yml config/database.yml

Optional change config/deploy.rb and deploy/production.rb to use it with your own server.

Run bundle to install required gems

To run locally with thin server:

gem install thin

thin start

###Credits:
Server side pagination:

http://code.ciphertrick.com/2015/08/31/server-side-pagination-in-angularjs/
https://github.com/michaelbromley/angularUtils/tree/master/src/directives/pagination

Logger:

http://stackoverflow.com/users/1633753/isaac-betesh

