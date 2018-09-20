require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'yaml'

task default: %w{server}

desc "start dev server"
task :server do
  exec "shotgun --server=puma --port=3000 config.ru"
end

task :test do
  exec "cutest test/**/*.rb"
end

def console(rack_env)
  desc "start #{rack_env} console"
  task :console do
    ENV['RACK_ENV'] = rack_env
    require './app'
    Pry.start
  end
end

def get_database_config
  @database_config = YAML.load_file('./app/config/database.yml')
  @db = Sequel.connect(@database_config["#{ENV['RACK_ENV']}"])
  Sequel.extension :migration, :core_extensions
end

def database(rack_env)
  ENV['RACK_ENV'] = rack_env
  
  namespace :db do
    desc "Prints current schema version in #{rack_env}"
    task :version do
      get_database_config
      version = if @db.tables.include?(:schema_info)
        @db[:schema_info].first[:version]
      end || 0
      puts "Schema Version: #{version}"
    end
  end
end

namespace :dev do
  console('development')
  database('development')
end

namespace :prod do
  console('production')
  # database('production')
end
