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
  token = Authenticator.new.authenticate
  unless token.nil?
    User.get_users(token)
  end
end

main
