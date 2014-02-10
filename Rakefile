require 'rubygems/package_task'

spec = Gem::Specification.load('timendeploy.gemspec')
Gem::PackageTask.new spec

desc "run all bacon specs"
task :spec do
  sh %{bacon -Ilib:spec spec/**/*_spec.rb}
end
task :test => :spec

desc "start server (main executable)"
task :start do
  sh %{bin/timendeploy}
end

desc "start server under thin (rackup)"
task :thin do
  sh %{thin -R bin/timendeploy.ru -p 9001 start}
end

desc "remove pkg files"
task :clean do
  rm_rf 'pkg'
end

desc "run specs"
task :default => :spec
