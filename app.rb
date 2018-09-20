require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')

# Load database.yml
DATABASE_CONFIG = YAML.load_file('./config/database.yml')

DB = Sequel.connect(DATABASE_CONFIG["#{ENV['RACK_ENV']}"])

require "cuba/render"
Cuba.plugin Cuba::Render
Cuba.settings[:render][:views] = "./app/views/"

Dir["./app/helpers/*.rb"].each { |file| require file }
Dir["./app/apis/*/*.rb"].each { |file| require file }
Dir["./app/apis/*.rb"].each { |file| require file }
