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
  exec "export RACK_ENV=test && cutest test/**/*.rb"
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
  @database_config = YAML.load_file('./config/database.yml')
  @db = Sequel.connect(@database_config["#{ENV['RACK_ENV']}"])
  Sequel.extension :migration, :core_extensions
end

def database(rack_env)
  short = 'test' if rack_env == 'test'
  short = 'dev' if rack_env == 'development'
  short = 'prod' if rack_env == 'production'
  ENV['RACK_ENV'] = rack_env
  get_database_config
  namespace :db do
    desc "Generate Schema text file. "
    task :schema do
      
      File.open("db/schema.txt", "w") do |writeable|
        Dir.glob("app/models/*").each.with_index do |file, idx|
          require_relative file
          model_name = file.split("\/").last.split('.').first
          if model_name.include?("_")
            model_name = model_name.split("_").map(&:capitalize).join
          else
            model_name = model_name.capitalize
          end
          writeable << model_name + "\n"
          writeable << "==================================================\n"
          Object.const_get(model_name).db_schema.each do |k,v|
            writeable << "#{k.to_s.ljust(20, ' ')}#{v[:db_type].to_s.rjust(30, ' ')}\n"
          end
          if Dir.glob("app/models/*").count == idx + 1
            writeable << "--------------------------------------------------"
          else
            writeable << "--------------------------------------------------\n\n"
          end
        end
      end
    end

    desc "Prints current schema version. "
    task :version do
      version = if @db.tables.include?(:schema_info)
        @db[:schema_info].first[:version]
      end || 0
      puts "Schema Version: #{version}"
    end

    desc "Perform migration up to latest migration available. "
    task :migrate do
      Sequel::Migrator.run(@db, "db/migrations")
      Rake::Task["#{short}:db:version"].execute
      # Rake::Task["#{short}:db:schema"].execute
    end

    desc "Perform rollback to specified target or full rollback as default. "
    task :rollback, :target do |t, args|
      args.with_defaults(:target => 0)
      Sequel::Migrator.run(@db, "db/migrations", :target => args[:target].to_i)
      Rake::Task["#{short}:db:version"].execute
    end

    desc "Perform migration reset (full rollback and migration). "
    task :reset do
      Sequel::Migrator.run(@db, "db/migrations", :target => 0)
      Sequel::Migrator.run(@db, "db/migrations")
      Rake::Task["#{short}:db:version"].execute
    end

  end
end

namespace :test do
  console('test')
  database('test')
end

namespace :dev do
  console('development')
  database('development')
end

namespace :prod do
  console('production')
  ## uncomment this line will add production database operation to your script
  # database('production')
end
