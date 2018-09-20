require 'pry'
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

namespace :dev do
  console('development')
end

namespace :prod do
  console('production')
end