class StaticPageController < ApplicationController
  before_action :check_params
  def main
  	 render :text => "Wrong arguments" if !check_params
  end
  def day
    render plain: params.inspect.to_s
  end
  private
  def check_params
  	params[:month] = Date.today.month if params[:month].nil?
  	params[:year] = Date.today.year if params[:year].nil?
  	params[:month].to_i.between?(1,12)
  end
end
