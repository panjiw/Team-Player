install:
	echo "Installing packages: this might take a while..."
	sudo yum -y install ruby-devel
	sudo yum -y install nodejs
	sudo yum -y install sqlite-devel
	sudo gem install rails
	sudo gem install bundler
	bundle config build.nokogiri --use-system-libraries
	sudo gem install nokogiri
	bundle install --without production
	bundle exec rake db:migrate RAILS_ENV=development
	echo "Success! Use 'rails s' to view the app at localhost:3000"

deploy:
	echo "Stashing any current changes..."
	git stash
	echo "Pulling fresh copy from master repo"
	git fetch origin master
	git reset --hard origin/master
	echo "Deploying to Herkoku"
	-heroku git:remote -a team-player
	git push heroku master
	heroku run rake db:migrate
	echo "Success! View it at https://team-player.herokuapp.com"
