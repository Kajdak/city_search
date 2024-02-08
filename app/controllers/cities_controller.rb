# frozen_string_literal: true

class CitiesController < ApplicationController
  before_action :set_city, only: %i[show update destroy]
  before_action :set_states, only: %i[index search]
  skip_before_action :verify_authenticity_token, only: %i[create update destroy]

  def index; end

  def show
    render json: @city
  end

  def create
    @city = City.new(city_params)
    if @city.save
      render json: @city, status: :created
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  def update
    if @city.update(city_params)
      render json: @city
    else
      render json: @city.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @city.destroy
    head :no_content
  end

  def search
    @cities = City.includes(:state).filter_by_state(params[:state_id]).filter_by_name(params[:name])

    respond_to do |format|
      format.html  { render 'index', cities: @cities }
      format.json  { render json: @cities }
    end
  end

  private

  def set_city
    @city = City.find(params[:id])
  end

  def set_states
    @states = State.all
  end

  def city_params
    params.require(:city).permit(:name, :state_id)
  end
end
