namespace :db do
  desc "Drop, recreate, migrate, and seed database in development"
  task :yolo => ["db:drop", "db:create", "db:migrate"]
end