require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV["RACK_ENV"] || 'development')

Dir["./app/apis/*/*.rb"].each { |file| require file }
Dir["./app/apis/*.rb"].each { |file| require file }
