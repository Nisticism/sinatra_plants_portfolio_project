class PlantsController < ApplicationController

  get '/:username/plants/new' do
      if logged_in? && current_user.username == params[:username]
        @plant = Plant.new
        erb :new
      else
        redirect to '/failure'
      end
    end

    post '/:username/plants/new' do
      if logged_in? && current_user.username == params[:username]
        @plant = Plant.find(params[:plant_id])
        erb :new
      else
        redirect to '/failure'
      end
    end

    
  
    post '/:username/plants' do
      if logged_in? && params[:username] == current_user.username
        if params[:plant][:quantity].is_number? || params[:plant][:quantity] == ""
          @plant = current_user.plants.build(params[:plant])
          if @plant.species != ""
            @plant.save
            redirect to "/#{current_user.username}/plants/#{@plant.id}"
          else
            @error = "Species cannot be blank."
            erb :new
          end
        else 
          @error = "Quantity must be a number."
          erb :new
        end
      else
        redirect to '/failure'
      end

    end
  
    get '/:username/plants/:id' do
      if logged_in? && params[:username] == current_user.username && @plant = Plant.find(params[:id])
        erb :'plants/show'
      else
        redirect to '/failure'
      end
    end
  
    get '/:username/plants/:id/edit' do
      if logged_in?
        @id = params[:id]
        @plant = Plant.find(@id)
        erb :'plants/edit'
      else
        redirect to '/failure'
      end
    end
  
    patch '/:username/plants/:id' do
      if logged_in?
        @plant = Plant.find_by_id(params[:id])
        if current_user == @plant.user
          if params[:plant][:quantity].is_number? || params[:plant][:quantity] == ""
            if params[:plant][:species] != ""
              @plant.update(params[:plant]) 
            redirect to "/#{current_user.username}/plants/#{@plant.id}"
            else
              @error = "Species cannot be blank."
              erb :'/plants/edit'
            end
          else 
            @error = "Quantity must be a number."
            erb :'/plants/edit'
          end
        else
          redirect to '/account'
        end
      else
       redirect to '/failure'
      end
    end
    

  
    delete '/:username/plants/:id' do
      @plant = Plant.find(params[:id])
      if @plant.user == current_user
        @plant.delete
        redirect to "/account"
      else
        redirect to '/failure'
      end
    end
end