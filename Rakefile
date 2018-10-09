require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'yaml'

task default: %w{server}

desc "start dev server"
task :server do
  exec "export RACK_ENV=development && shotgun --server=thin --port=3000 config.ru"
end

task :test do
  exec "export RACK_ENV=test && cutest test/**/*.rb"
end

def console
  desc "start console"
  task :console do
    require './app'
    Pry.start
  end
end

def get_database_config
  rack_env = ENV['RACK_ENV'] || "development"
  @database_config = YAML.load_file('./config/database.yml')
  @db = Sequel.connect(@database_config[rack_env])
  Sequel.extension :migration, :core_extensions
end

def database
  get_database_config

  namespace :db do
    desc "Generate migration"
    task :generate, :source do |t, args|
      name = args[:source]
      f_count = Dir.glob("./db/migrations/*").count

      version = if @db.tables.include?(:schema_info)
        @db[:schema_info].first[:version]
      end || 0

      action, tbl = name.split('_')
      begin

        template = Tilt.new("./db/templates/#{action}.str").render Object.new, tbl: tbl
        puts "More info at https://github.com/jeremyevans/sequel/blob/master/doc/schema_modification.rdoc"
        if f_count == version
          f_name = "#{version + 1}_#{name}.rb"
          File.open("./db/migrations/#{f_name}", "w") do |f|
            f.write template
          end
        else
          puts "Invalid file count in migrations."
        end
      rescue Exception => e
        puts "Invalid action: #{action}"
      end

    end

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
          writeable << ["="].cycle(50).to_a.join + "\n"
          Object.const_get(model_name).db_schema.each do |k,v|
            writeable << "#{k.to_s.ljust(20, ' ')}#{v[:db_type].to_s.rjust(30, ' ')}\n"
          end
          writeable << ["-"].cycle(50).to_a.join + "\n\n"
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
      Rake::Task["db:version"].execute
      Rake::Task["db:schema"].execute
    end

    desc "Perform rollback to specified target or full rollback as default. "
    task :rollback, :target do |t, args|
      args.with_defaults(:target => 0)
      Sequel::Migrator.run(@db, "db/migrations", :target => args[:target].to_i)
      Rake::Task["db:version"].execute
    end

    desc "Perform migration reset (full rollback and migration). "
    task :reset do
      Sequel::Migrator.run(@db, "db/migrations", :target => 0)
      Sequel::Migrator.run(@db, "db/migrations")
      Rake::Task["db:version"].execute
    end

  end
end

console()
database()
