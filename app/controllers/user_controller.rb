class UserController < ApplicationController

    get "/" do
        redirect to '/index'
      end
    
      post "/login" do
        user = User.find_by(:username => params[:username])
            if user && user.authenticate(params[:password])
                session[:user_id] = user.id
                redirect to "/account"
            else
                redirect to "/failure"
            end
      end

      get "/index" do
        redirect to '/account' if logged_in?
        erb :index
      end 

  
    
      get "/signup" do
        redirect to '/account' if logged_in?
        erb :signup
      end 
    
      get "/login" do
        redirect to '/account' if logged_in?
        erb :login
      end
    
      post "/signup" do
        if !User.find_by(:username => params[:username])
          user = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])
          if user.username.length > 0 && params[:password] != ""
            user.save
            session[:user_id] = user.id
            redirect to "/account"
          else 
            @error = "Must provide a valid username and password."
            erb :signup
          end
        else 
          @error = "Username already in use."
          erb :signup
        end
      end
    
      get '/account' do
        if logged_in?
        redirect to "/#{current_user.username}"
        else
          redirect to "/failure"
        end
      end

      get '/failure' do 
        erb :failure
      end

      get '/:username' do
        if logged_in? && params[:username] == current_user.username

          @plants = current_user.plants
          erb :account
        else
          redirect to '/failure'
        end
      end
      
      delete '/logout' do
        session.clear
        redirect to '/'
      end
    
     

end