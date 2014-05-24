# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
require 'jasmine'
load 'jasmine/tasks/jasmine.rake'

require 'fileutils'

task :install do
  sh %{ 
    sudo yum -y install ruby-devel                          &&
    sudo yum -y install nodejs                              &&
    sudo yum -y install sqlite-devel                        &&
    sudo gem install rails                                  &&
    sudo gem install bundler                                &&
    bundle config build.nokogiri --use-system-libraries     &&
    sudo gem install nokogiri                               &&
    bundle install --without production                     &&
    bundle exec rake ENV=RAILS_DEV                          &&
    bundle exec rake db:migrate
  }
end
