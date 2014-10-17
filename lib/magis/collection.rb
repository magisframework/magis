class Collection
  attr_accessor :resource, :request, :config, :current_user, :type

  def initialize(current_user, params, request)
    self.resource = params[:resource]
    self.request = request
    self.current_user = current_user

    self.config = Magis.load_collection(resource)
    self.type = self.config["type"]
  end

  def source
    if self.config["type"] == "json"
      JSON.parse( IO.read(self.config["source"]+".json") )
    else
      Magis.db[resource]
    end
  end

  def is_public?
  end

  def is_accessable?
    user_access = config["user_access"]
    if user_access
      id = user_access["id"]
      type = user_access["type"]
    end
    puts "METHOD"
    puts request.request_method
    puts "METHOD END"
    if config["public"][request.request_method] || [request.request_method]
      true
    else
      false
    end
  end
  
  def check_verb(method)
    if (collection_config["public"] && method == "GET" ) || (collection_config["public"] && method == collection_config[method])
      true
    else
      false
    end
  end
end