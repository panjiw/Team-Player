install:
	sudo yum install ruby-devel
	sudo yum install nodejs
	sudo yum install sqlite-devel
	sudo gem install rails
	sudo gem install bundler
	bundle config build.nokogiri --use-system-libraries
	sudo gem install nokogiri
	bundle install --without production
	bundle exec rake ENV=RAILS_DEV
	bundle exec rake db:migrate
