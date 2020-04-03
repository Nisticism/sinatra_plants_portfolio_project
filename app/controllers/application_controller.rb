require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :account
    else
      erb :index
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
    user = User.new(:name => params[:name], :username => params[:username], :email => params[:email], :password => params[:password])
    if user.username.length > 0 && params[:password] != ""
      user.save
			redirect "/login"
		else
			redirect "/failure"
		end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    @plants = @user.plants
    erb :account
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

  get '/:username/new' do
    if logged_in?
      @user = User.find(session[:user_id])
      @plants = @user.plants
      @id = @plants.size + 1
      erb :new
    else
      redirect to '/failure'
    end
  end

  post '/:username/plants/:id' do
    @user = User.find(session[:user_id])
    @plant = Plant.new(species: params["species"], sprout_date: params["sprout_date"], price: params["price"], quantity: params["quantity"], user_id: @user.id)
    if @plant.species
      @plant.save
      @id = @plant.id
      erb :'/plants/show'
    else 
      redirect to '/failure'
    end
  end

  get '/:username/plants/:id' do
    if logged_in?
      @user = User.find(session[:user_id])
      @plant = Plant.find(params[:id])
      erb :'plants/show'
    else
      redirect to '/failure'
    end
  end

  get '/:username/plants/:id/edit' do
    if logged_in?
      @id = params[:id]
      @user = User.find(session[:user_id])
      @plant = Plant.find(@id)
      erb :'plants/edit'
    else
      redirect to '/failure'
    end
  end
  
  patch '/:username/plants/:id' do
    if logged_in?
      @plant = Plant.find(params[:id])
      @plant.update(params[:plant])
      @plant.save
      redirect to '/:username/plants/#{@plant.id}'
    else
      redirect to '/failure'
    end
  end

  post '/:username/plants' do 
    plant = Plant.new(params[:species])
  end

  get '/accounts' do
    @users = User.all
    erb :'/accounts/index' 
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    #binding.pry
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/account"
		else
			redirect "/failure"
		end
  end

  delete '/:username/plants/:id' do
    @plant = Plant.find(params[:id])
    @plant.delete
    redirect to '/account'
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
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
