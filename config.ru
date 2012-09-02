require File.expand_path '../boot.rb', __FILE__

Notifire::Server.set({
  :port    => ARGV.first || 8080,
  :logging => true
})

run Notifire::Server