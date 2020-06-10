
build:
	bundle install

test:
	echo "running unit tests"
	COVERAGE=true bundle exec rspec
	echo "running end to end tests"
	bundle exec rspec e2e_spec.rb
	open coverage/index.html
