require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')
require "cuba/render"

# Load database.yml
DATABASE_CONFIG = YAML.load_file('./config/database.yml')

DB = Sequel.connect(DATABASE_CONFIG["#{ENV['RACK_ENV']}"])
# # setup database extensions
Sequel::Model.plugin :timestamps, create: :created_at, update: :updated_at

Cuba.plugin Cuba::Render
Cuba.settings[:render][:views] = "./app/views/"

Dir["./app/helpers/*.rb"].each { |file| require file }
Dir["./app/apis/*/*.rb"].each { |file| require file }
Dir["./app/apis/*.rb"].each { |file| require file }
