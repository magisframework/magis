module Rack
  class Request
    def subdomains(tld_len=1) # we set tld_len to 1, use 2 for co.uk or similar
      # cache the result so we only compute it once.
      @env['rack.env.subdomains'] ||= lambda {
        # check if the current host is an IP address, if so return an empty array
        return [] if (host.nil? ||
                      /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
        host.split('.')[0...(1 - tld_len - 2)] # pull everything except the TLD
      }.call
    end
  end
end

module Magis
  include Mongo
  @@home_folder = ""
  def self.framework_path
    @@local_path ||= File.expand_path("../../", File.dirname(__FILE__))
  end
  def self.file(filename)
    local_path = self.framework_path
    project_path = File.expand_path(self.home_folder)

    file_contents = nil
    full_file_name = project_path + filename

    if File.file?(full_file_name)
      file_contents = File.new(full_file_name).readlines
    elsif File.file?(local_path + filename)
      full_file_name = local_path + filename
      file_contents = File.new(full_file_name).readlines
    end
    
    file_contents
  end
  
  def self.application
    Api
  end
  
  def self.env
    @@environment ||= ENV['RACK_ENV']
    setup ||= @@environment == "setup"
    production ||= @@environment == "production"
    development ||= @@environment == "development"
    test ||= @@environment == "test"
    @environments ||= OpenStruct.new({
      setup?: setup, 
      production?: production, 
      development?: development, 
      test?: test
    })
    @environments
  end

  def self.home_folder
    Dir.pwd
  end
  
  def self.set_db
    uri = ENV["DB_URI"] || Magis.load_configuration("database")["uri"]

    if uri
      client = MongoClient.from_uri(uri)
    else
      client = MongoClient.new 
    end

    db_name = ENV["DB_NAME"] || Magis.load_configuration("database")["name"]

    @@db = client[db_name]
  end
  
  def self.db
    @@db
  end

  def self.load_collection(file)
    if File.exist?(home_folder + "/collections/" + file + ".yml")
      YAML.load_file(home_folder + "/collections/" + file + ".yml")
    else
      Hash.new
    end
  end
  
  def self.load_configuration(file)
    @@files ||= Hash.new
    if File.exist?(home_folder + "/config/" + file + ".yml")
      @@files[file] ||= YAML.load_file(home_folder + "/config/" + file + ".yml")
    else
      Hash.new
    end
  end
  
  def self.omni_auth_config(type)
    configuration = self.load_configuration(type)
    configuration[:id] ||= nil
    configuration[:secret] ||= nil
      
    configuration
  end
  
  def self.start
    Dir["/api/*.rb"].each {|file| require file }
    self.set_db
  end
end