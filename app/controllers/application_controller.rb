require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  
  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

end
