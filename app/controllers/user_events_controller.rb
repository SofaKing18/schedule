# UserEventsController
class UserEventsController < ApplicationController
  before_action :set_user_event, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:edit, :update, :destroy]
  # GET /user_events
  # GET /user_events.json
  def index
    @user_events = UserEvent.where(user_id: current_user.id).order(start_date: :desc)
  end

  # GET /user_events/1
  # GET /user_events/1.json
  def show
    redirect_to edit_user_event_path(@user_event)
  end

  # GET /user_events/new
  def new
    @user_event = UserEvent.new
  end

  # GET /user_events/1/edit
  def edit
    raise 'no permission' unless can? :update, @user_event
  end

  # POST /user_events
  # POST /user_events.json
  def create
    @user_event = UserEvent.new(user_event_params)
    if @user_event.save
      redirect_to controller: 'static_page', action: 'main', month: @user_event.start_date.month, year: @user_event.start_date.year
    else
      render :new
    end
  end

  # PATCH/PUT /user_events/1
  # PATCH/PUT /user_events/1.json
  def update
    raise 'no permission' unless can? :update, @user_event
    if @user_event.update(user_event_params)
      redirect_to user_events_url, notice: 'Record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_events/1
  # DELETE /user_events/1.json
  def destroy
    raise 'no permission' unless can? :destroy, @user_event
    @user_event.destroy
    redirect_to user_events_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_event
    @user_event = UserEvent.find(params[:id])
  end

  def check_permission
    raise 'no permission' unless can? action_name.to_sym, @user_event
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_event_params
    modified_params = params.require(:user_event).permit(:name, :start_date, :end_date, :repeat_type, :hidden)
    modified_params['user_id'] = current_user.id unless current_user.nil?
    modified_params
  end
end
