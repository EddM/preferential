Gem::Specification.new do |s|
  s.name = "preferential"
  s.version = "0.0.1"
  s.date = "2015-05-13"
  s.summary = "Extract preference data from your Rails models quickly and painlessly"
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
