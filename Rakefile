require 'opal'
require 'sprockets'
require 'opal-jquery'
 
desc "Build our app to conway.js"
task :build do
  env = Sprockets::Environment.new
  Opal.paths.each { |p| env.append_path p }
  env.append_path "app"
 
  File.open("conway.js", "w+") do |out|
    out << env["conway"].to_s
  end
end