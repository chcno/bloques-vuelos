class DashboardController < ApplicationController
    before_action :redirect_non_admins, only: [:index]

  def index
      @next_flights = FlightBlock
    .where("start_time > ?", Time.zone.now)
    .order(:start_time)
    .limit(5)

  @maintenances = Maintenance
    .where("end_time > ?", Time.zone.now)

  @pending_users = User.pending
  end


 def profile
  @next_flights = FlightBlock
    .where("start_time >= ?", Time.zone.now)
    .where("instructor_id = :id OR student_id = :id", id: current_user.id)
    .order(:start_time)

  #@aircrafts = Aircraft.where(status: "Active")
    @my_availabilities = current_user.availabilities.order(:day, :start_time) if user_signed_in?

end

  private

  def redirect_non_admins
    unless current_user.admin?
      redirect_to profile_dashboard_index_path
    end
  end
end
