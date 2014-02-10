#!/usr/bin/env rackup
begin
  require 'rubygems'
  require 'timendeploy'
rescue LoadError
  require File.dirname(__FILE__) + '/../lib/timendeploy'
end

use Rack::CommonLogger
use Rack::Lint
run Timendeploy::RackApp.new
