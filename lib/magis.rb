require "magis/version"
require 'bundler'
Bundler.require(:default)

#######################
# FAYE SERVER
#######################
require 'faye'

#######################
# REQUIRE SINATRA
#######################
require 'sinatra'
require 'sinatra/asset_pipeline'

#######################
# REQUIRE SOCIAL AUTH
#######################
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'omniauth-google-oauth2'

#######################
# SOCIAL INTERACTIONS
#######################
require 'koala'

#######################
# SUPPORTING FILES
#######################
require 'yaml'

##################################
# REQUIRE MONGO JSON INFLECTOR
##################################
require 'mongo'
require 'json'
require 'active_support/inflector'

#################################
# REQUIRE BASE AND COLLECTIONS
#################################
require_relative 'magis/collections'

###############################
# REQUIRE MAIN LIB
###############################
require_relative 'magis/base'

###############################
# REQUIRE MAIN LIB
###############################
require_relative 'magis/auths/fb'
require_relative 'magis/auths/twitter'
require_relative 'magis/auths/google'

###############################
# REQUIRE MAIN LIB
###############################
require_relative 'magis/web'

require_relative 'magis/collection'

###############################
# REQUIRE API FILES
###############################
Dir[File.dirname(Magis.home_folder) + '/api/*.rb'].each do |file| 
  require file.gsub(".rb", "")
end

Magis.start