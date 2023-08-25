$LOAD_PATH << './lib'
require 'auth'
require 'user'
require 'uri'
require 'net/http'
require 'digest'
require 'json'

include Auth
include User

def main
  # Retrieve an authentication token
  token = Authenticator.new.authenticate
  # Ensure the token exists
  unless token.nil?
    # and proceed with the get_users request to the API server
    User.get_users(token)
  end
end

main
