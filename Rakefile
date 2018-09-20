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
  namespace :db do
    desc "Prints current schema version. #{rack_env}"
    task :version do
      ENV['RACK_ENV'] = rack_env
      get_database_config
      version = if @db.tables.include?(:schema_info)
        @db[:schema_info].first[:version]
      end || 0
      puts "Schema Version: #{version}"
    end

    desc "Perform migration up to latest migration available. #{rack_env}"
    task :migrate do
      ENV['RACK_ENV'] = rack_env
      get_database_config
      Sequel::Migrator.run(DBM, "db/migrations")
      Rake::Task['db:version'].execute
      Rake::Task['db:schema'].execute
    end

    desc "Perform rollback to specified target or full rollback as default. #{rack_env}"
    task :rollback, :target do |t, args|
      ENV['RACK_ENV'] = rack_env
      get_database_config
      args.with_defaults(:target => 0)
      Sequel::Migrator.run(dbm, "db/migrations", :target => args[:target].to_i)
      Rake::Task['db:version'].execute
    end

    desc "Perform migration reset (full rollback and migration). #{rack_env}"
    task :reset do
      ENV['RACK_ENV'] = rack_env
      get_database_config
      Sequel::Migrator.run(dbm, "db/migrations", :target => 0)
      Sequel::Migrator.run(dbm, "db/migrations")
      Rake::Task['db:version'].execute
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
