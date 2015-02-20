namespace :db do
  desc "Drop, recreate, migrate, and seed database in development"
  task :yolo => ["db:drop", "db:create", "db:migrate"]

  desc "Re-seed demo page"
  task :seed_demo => :environment do
    load(Rails.root.join('db', 'seeds', 'demo.rb'))
  end

end

desc "Pings PING_URL to keep a dyno alive"
task :dyno_ping do
  require "net/http"

  if ENV['PING_URL']
    uri = URI(ENV['PING_URL'])
    Net::HTTP.get_response(uri)
  end
end