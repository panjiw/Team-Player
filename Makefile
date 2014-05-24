install:
	sudo yum -y install ruby-devel && sudo yum -y install nodejs && sudo yum -y install sqlite-devel && sudo gem install rails && sudo gem install bundler && bundle config build.nokogiri --use-system-libraries && sudo gem install nokogiri && bundle install --without production && bundle exec rake db:migrate RAILS_ENV=development
