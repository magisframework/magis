class TwitterTether
  def self.store(user_params)
    user_raw = user_params["extra"]["raw_info"] 
    
    user = Magis.db["users"].find(screenName: user_raw["screen_name"]).first
    
    user_info = Hash.new
    
    if user_raw["screen_name"]
      user_info[:screenName] = user_raw["screen_name"]
    end
    
    if user_raw["name"]
      user_info[:firstName] = user_raw["name"].split(" ").first
      user_info[:lastName] = user_raw["name"].split(" ").last
    end
    
    if user_raw["gender"]
      user_info[:gender] = user_raw["gender"]
    end
    
    if user_raw["id"]
      user_info[:uid] = user_raw["id"]
    end
    
    if user_raw["profile_image_url_https"]
      user_info[:image] = user_raw["profile_image_url_https"]
    end
    
    if user_raw["timezone"]
        user_info[:timezone] = user_raw["timezone"]
    end
    
    if user_params["credentials"]["token"]
      user_info[:token] = user_params["credentials"]["token"]
    end
    
    if user_params["credentials"]["secret"]
      user_info[:token_secret] = user_params["credentials"]["secret"]
    end
    
    user_info[:provider] = :twitter
    
    if user
      Magis.db["users"].update({"_id" => user["_id"]}, {"$set" => user_info})
    else
      user = Magis.db["users"].insert(user_info)
    end
    
    user
  end
end