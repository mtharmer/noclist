# Running the server
The "BADSEC" API server can be started using the following command:
`docker run --rm -p 8888:8888 adhocteam/noclistdocker --rm -`

# Running this script
This script can be run by simply using the "ruby" command:
`ruby noclist.rb`

# Dependencies
This script was written using Ruby 3 - please use at least Ruby 3.0 when running.

# Testing
The included Gemfile includes the required Gems for testing, and can be installed using bundler.

If you do not have bundler, please install using:
`gem install bundler`

Then install the gems with the following command:
`bundle install`

And finally, run the test suite using this command:
`bundle exec rspec`
