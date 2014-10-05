Gem::Specification.new do |s|
  s.name        = 'magis'
  s.version     = '0.0.1'
  s.date        = '2014-08-12'
  s.summary     = "Magis Framework"
  s.description = "Magis Framework Gem"
  s.authors     = ["Carson Wright"]
  s.email       = 'carsonnwright@gmail.com'
  s.files       = Dir["lib/**/*"] + Dir["magis/**/*"] + Dir["boilerplate/**/*"] + ["Rakefile", "README.md"]
  s.require_paths = ["lib"]
  s.executables << 'magis'
  s.homepage    = 'localhost:3000'
  s.add_dependency "sinatra", ["= 1.4.5"]
  s.add_dependency "sinatra-asset-pipeline", ["= 0.5.0"]
  s.add_dependency "puma", ["= 2.9.1"]
  s.add_dependency 'bson_ext', ['= 1.11.1']
  s.add_dependency 'mongo', ['= 1.11.1']
  s.add_dependency 'i18n', ['= 0.6.11']
  s.add_dependency 'json', ['= 1.8.1']
  s.add_dependency 'activesupport-inflector', ['= 0.1.0']
  s.add_dependency 'faye', ['= 1.0.3']
  s.add_dependency 'koala', ['= 1.10.1']
  
  s.add_dependency 'omniauth', ['= 1.2.2']
  s.add_dependency 'omniauth-oauth2', ['= 1.2.0']
  s.add_dependency 'omniauth-facebook', ['= 2.0.0']
  s.add_dependency 'omniauth-twitter', ['= 1.0.1']
  s.add_dependency 'omniauth-google-oauth2', ['= 0.2.5']
  
  s.add_development_dependency 'pry', ['= 0.10.1']
  s.add_development_dependency 'rspec', ['= 3.1.0']
  s.add_development_dependency 'rack-test', ['= 0.6.2']
  s.add_development_dependency 'simplecov', ['= 0.9.1']
  s.add_development_dependency 'webmock', ['= 01.19.0']
  s.add_development_dependency 'capybara', ['= 2.4.2']
  s.add_development_dependency 'selenium-webdriver', ['= 2.43.0']   
  s.add_development_dependency 'poltergeist', ['= 1.5.1'] 
  s.license     = 'MIT'
end
