# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Laod the sportdb
require 'sportdb'
require 'sportdb/service'
require 'queries'

# Initialize the Rails application.
MlsAlmanac::Application.initialize!
