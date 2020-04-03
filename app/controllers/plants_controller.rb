class PlantsController < ApplicationController

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
    
      # get '/:username/plants/:id' do
      #   if logged_in?
      #     @user = User.find(session[:user_id])
      #     @plant = Plant.find(params[:id])
      #     erb :'plants/show'
      #   else
      #     redirect to '/failure'
      #   end
      # end
    
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
          @plant = Plant.find_by_id(params[:id])
          @plant.update(params[:plant])
          @plant.save
          @user = User.find(session[:user_id])
          erb :'plants/show'
        else
          redirect to '/failure'
        end
      end
      
    
      post '/:username/plants' do 
        plant = Plant.new(params[:species])
      end
    
      delete '/:username/plants/:id' do
        @user = User.find(session[:user_id])
        @plant = Plant.find(params[:id])
        @plant.delete
        redirect to "/account"
      end

end