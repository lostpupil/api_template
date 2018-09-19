task default: %w{server}

desc "start server"
task :server do
  exec "shotgun --server=puma --port=3000 config.ru"
end