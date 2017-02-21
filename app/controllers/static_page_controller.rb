# StaticPageController
class StaticPageController < ApplicationController
  before_action :check_params

  def main; end

  def day; end

  private

  def check_params
    params[:month] = Time.zone.today.month if params[:month].nil?
    params[:year] = Time.zone.today.year if params[:year].nil?
    params[:day] = Time.zone.today.day if params[:day].nil?

    raise 'Wrong Arguments' unless params[:month].to_i.between?(1, 12) && params[:day].to_i.between?(1, 31)
  end
end
