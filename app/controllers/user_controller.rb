class UserController < ApplicationController

    get "/" do
        if logged_in?
          @user = User.find(session[:user_id])
          erb :account
        else
          erb :index
        end
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
    
      # get '/sequoia.jpg'
      #   erb :index
      # end
    
      get "/signup" do
        erb :signup
      end 
    
      get "/login" do
        erb :login
      end
    
      post "/signup" do
        if !User.find_by(:username => params[:username])
          user = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])
        else
          redirect to '/failure'
        end
        if user.username.length > 0 && params[:password] != ""
          user.save
                redirect to "/login"
            else
                redirect to "/failure"
            end
      end
    
      get '/account' do
        @user = User.find_by_id(session[:user_id])
        if @user && logged_in?
          @plants = @user.plants
          erb :account
        else
          redirect to '/failure'
        end
      end
    
      get '/:username' do
        if logged_in?
          @user = User.find(session[:user_id])
          @plants = @user.plants
          erb :account
        else
          redirect to '/failure'
        end
      end

      get '/accounts' do
        @users = User.all
        erb :'/accounts/index' 
      end

      post "/failure" do
        erb :failure
      end
    
      get '/failure' do 
        erb :failure
      end
    
      delete '/logout' do
        session.clear
        redirect to '/'
      end
    
      helpers do
        def logged_in?
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
      end

end