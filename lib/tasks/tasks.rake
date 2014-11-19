namespace :db do
  desc "Drop, recreate, migrate, and seed database"
  task :yolo => ["db:drop", "db:create", "db:migrate", "db:seed"]
end