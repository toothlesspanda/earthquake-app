# lib/tasks/initial_setup.rake
namespace :data do
  desc "Populates the database with initial data if it's empty"
  task :initial_setup => :environment do
    if Earthquake.all.empty?
      StoreRecentEarthquakes.new.call
    end
  end
end
