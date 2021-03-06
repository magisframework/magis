class FBTether
  def self.store(user_params)
    user_raw = user_params["extra"]["raw_info"]
    user = Magis.db["users"].find(email: user_raw["email"]).first
    
    user_info = Hash.new
    
    if user_raw["email"]
      user_info[:email] = user_raw["email"]
    end
    
    if user_raw["first_name"]
      user_info[:firstName] = user_raw["first_name"]
    end
    
    if user_raw["last_name"]
      user_info[:lastName] = user_raw["last_name"]
    end
    
    if user_raw["gender"]
      user_info[:gender] = user_raw["gender"]
    end
    
    
    if user_params["info"]["image"]
      user_info[:image] = user_params["info"]["image"]
    end
    
    if user_raw["id"]
      user_info[:uid] = user_raw["id"]
    end
    
    if user_raw["locale"] 
      user_info[:locale] = user_raw["locale"]
    end
    
    if user_raw["timezone"]
        user_info[:timezone] = user_raw["timezone"]
    end
    
    if user_params["credentials"]["token"]
      user_info[:accessToken] = user_params["credentials"]["token"]
    end
    
    user_info[:provider] = :facebook
    
    if user
      Magis.db["users"].update({"_id" => user["_id"]}, {"$set" => user_info})
    else
      Magis.db["users"].insert(user_info)
    	user = Magis.db["users"].find(email: user_raw["email"]).first
    end
    
    user
  end
  
  def self.friends(user)
    graph = Koala::Facebook::API.new(user["accessToken"])

    friends = Magis.db["friends"].find(userId: user["_id"]).first
    fb_friends = graph.get_connections("me", "friends")
    
    if friends
	    friends_list = Magis.db["friends"].update({userId: user["_id"]}, {"$set" => {friends: fb_friends}})
		else
     	Magis.db["friends"].insert({userId: user["_id"], friends: fb_friends})
    end
	  
    Magis.db["friends"].find(userId: user["_id"]).first["friends"]
  end
end