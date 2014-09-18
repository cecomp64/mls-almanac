# Grab the environment - connect to appropriate DB
require File.expand_path('../../../config/environment', __FILE__)

desc 'Create the necessary schema from scratch.  This should only be run once.'
task :create do
  puts "Creating LogDb..."
  LogDb.create
  puts "Creating ConfDb..."
  ConfDb.create
  puts "Creating TagDb..."
  TagDb.create
  puts "Creating WorldDb..."
  WorldDb.create
  puts "Creating PersonDb..."
  PersonDb.create
  puts "Creating SportDb..."
  SportDb.create

end

desc 'Seed the database with World info.'
task :init do
  # Country data
  #WorldDb.read_setup('setups/all', find_data_path_from_gemfile_gitref('world.db'))
  us_regions = ['continents', 'north-america/countries', 'north-america/us-united-states/regions', 'north-america/us-united-states/cities']
  WorldDb.read(us_regions, SportDb.test_data_path + '/world.db')

  # Season data
  SportDb.read_builtin
end

desc 'Update the sports data to the latest in github.'
task :update do
  SportDb.read_setup('setups/all_stats', find_data_path_from_gemfile_gitref('major-league-soccer'))
end

desc 'Update the sports data to the latest in github. Only select most recent years to keep size of DB small'
task :update_recent => [:update_2014, :update_standings] do
end

task :update_2014 do
  SportDb.read_setup('setups/sample_stats', find_data_path_from_gemfile_gitref('major-league-soccer'))
end

task :update_standings do
  Event.all.each do |event|
    es = SportDb::Model::EventStanding.find_by_event_id(event.id)
    if (!es)
      es = SportDb::Model::EventStanding.create(event: event)
    end
    
    # Update standings
    es.recalc!
  end
end

task :seed_all => [:init, :update] do
end

desc 'Remove all entries from the DB (but keep the tables)'
task :delete do
  LogDb.delete!
  ConfDb.delete!
  TagDb.delete!
  WorldDb.delete!
  PersonDb.delete!
  SportDb.delete!
end
