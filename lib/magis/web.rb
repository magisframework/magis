class Api < Sinatra::Base
  use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => ENV['SESSION_DOMAIN'] || Magis.load_configuration('app')["session_domain"],
                           :secret => ENV['SESSION_SECRET'] || Magis.load_configuration('app')["session_secret"]
  
  use Faye::RackAdapter, :mount => '/faye', :timeout => 25

  register Sinatra::AssetPipeline

  use OmniAuth::Builder do
    google = Magis.omni_auth_config("google")
    google_id = ENV["GOOGLE_ID"] || google["id"] || ""
    google_secret = ENV["GOOGLE_SECRET"] || google["secret"] || ""
    
    facebook = Magis.omni_auth_config("facebook")
    facebook_id = ENV["FACEBOOK_ID"] || facebook["id"] || ""
    facebook_secret = ENV["FACEBOOK_SECRET"] || facebook["secret"] || ""
    
    twitter = Magis.omni_auth_config("twitter")
    twitter_id = ENV["TWITTER_ID"] || twitter["id"] || ""
    twitter_secret = ENV["TWITTER_SECRET"] || twitter["secret"] || ""
    
    provider :facebook, facebook_id, facebook_secret, scope: "email, user_friends"
    provider :twitter, twitter_id, twitter_secret
    provider :google_oauth2, google_id, google_secret, {
      name: "google",
      scope: "userinfo.email, userinfo.profile, plus.me, http://gdata.youtube.com",
      prompt: "select_account",
      image_aspect_ratio: "square",
      image_size: 50,
    }
  end
  
  before /^(?!\/(join|payment))/ do
    @app = Magis.load_configuration("app")
    if @app && @app["subdomain_scope"] && request.subdomains[0] != @app["subdomain_scope"]["home"]
      @subdomain_scope = true
      @subdomain = request.subdomains[0]
    end
  end

  get '/magis.js' do
    content_type :js
    if current_user
      user = current_user
      user["_id"] = user["_id"].to_s
      current_user_json = user.to_json
    else
      current_user_json = {}.to_json
    end

    js = Magis.file('/magis/js/finch.min.js') + Magis.file('/magis/js/main.js') + ["\n"]
    js += ["currentUser = #{current_user_json};"] + ["\n"]
    js += Magis.file('/magis/js/current_user.js') + ["\n"]
    if Magis.env.setup?
      js += Magis.file('/magis/js/setup.js')
    end
    js
  end

  get '/' do
    if Magis.env.setup?
      send_file File.join(Magis.framework_path, "magis/html/setup.html")
    else
      if @subdomain_scope
        send_file File.join(settings.public_folder, @subdomain, '/index.html')
      else
        send_file File.join(settings.public_folder, 'index.html')
      end
    end
  end
  
  get '/pages/:page' do
    if @subdomain_scope
      send_file File.join(settings.public_folder, @subdomain, "pages/#{params[:page]}.html")
    else
      send_file File.join(settings.public_folder, "pages/#{params[:page]}.html")
    end
  end
 
  get '/auth/:provider/callback' do
    case params[:provider]
    when "facebook"
      user = FBTether.store(request.env['omniauth.auth'])
    when "twitter"
      user = TwitterTether.store(request.env['omniauth.auth'])
    when "google"
      user = GoogleTether.store(request.env['omniauth.auth'])
    end

    if user
      session[:user_id] = user["_id"]
    end
    redirect "/"
  end
  
  get '/me' do
    content_type :json

    current_user.to_json
  end

  get '/friends' do
    content_type :json
    friends.to_json
  end

  delete '/logout' do
    session[:user_id] = ""
  end

  get "/favicon.ico" do
  end

  post "/setup/:name" do
    if Magis.env.setup?
      config = params[params[:name]]
      File.open(Magis.home_folder+"/config/#{params[:name]}.yml", 'w') do |f| 
        f.write config.to_yaml
      end
      ""
    end
  end

  def current_user
    @user ||= Magis.db["users"].find(_id: session[:user_id]).to_a.first || Hash.new
    @user
  end

	def friends
    Array.new
    if current_user["provider"].to_s == "facebook"
		  @friends ||= FBTether.friends(current_user)
    end
  end

  set :public_folder, 'public'
end