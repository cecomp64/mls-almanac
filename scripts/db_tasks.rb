require 'optparse'
require File.expand_path('../../config/environment', __FILE__)

# Parse the command-line for an action to perform
def parse_options
  options = {}

  # Some defaults
  options[:action] = "none"

  opts = OptionParser.new do |opt|
    opt.banner = "Usage: rails runner db_tasks -a ACTION"

    #opt.on('-a', '--action', 'Print debug information') do
    #  options[:verbose] = Logger::DEBUG
    #end

    opt.on('-a', '--action ACTION', 'The name of a task to perform.  One of [init, destroy, update]') do |action|
      options[:action] = action
    end

    #opt.on('-a', '--aux_file file1,file2,file3,...', Array, 'Helper files for formatting.  e.g. For roster, these can be team .yml files') do |aux|
      #if (aux.kind_of?(Array))
        #options[:aux] = aux
      #else
        #options[:aux] = [aux]
      #end
    #end
  end

  opts.parse!
  return options
end

def init
  LogDb.create
  ConfDb.create
  TagDb.create
  WorldDb.create
  PersonDb.create
  SportDb.create

  # How do I pull in data from git?
  WorldDb.read_setup('setups/us', 'https://raw.githubusercontent.com/openmundi/world.db/master')
  #SportDb.read_setup('setups/all_stats', '')
end

options = parse_options

case options[:action]
#case ENV['ALMANAC_TASK']
when "init"
  init
end
