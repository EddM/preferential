$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "preferential/version"

Gem::Specification.new do |s|
  s.name = "preferential"
  s.version = Preferential::Version
  s.date = "2015-05-13"
  s.summary = "Extract preference data from your Rails models quickly and painlessly"
  s.description = "Sometimes storing preference data for users (or other types of object) can result in " \
                  "database tables with tons of very infrequently-accessed columns. This isn't always a problem, " \
                  "especially if you optimise your queries everywhere - but sometimes doing this is unwieldy. " \
                  "Preferential is a Rails gem that can make the extraction of this \"metadata\" to another table " \
                  "quick and painless."

  s.authors = ["Edd Morgan"]
  s.email = "edd@eddmorgan.com"
  s.files = Dir["lib/**/*", "README.md"]
  s.homepage = "https://github.com/EddM/preferential"
  s.license = "GPL"

  s.add_dependency "activerecord", "~> 3.2"

  s.add_development_dependency "rspec"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "database_cleaner"
end
