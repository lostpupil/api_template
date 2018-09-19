require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')

require "cuba/render"
Cuba.plugin Cuba::Render
Cuba.settings[:render][:views] = "./app/views/"

Dir["./app/apis/*/*.rb"].each { |file| require file }
Dir["./app/apis/*.rb"].each { |file| require file }
