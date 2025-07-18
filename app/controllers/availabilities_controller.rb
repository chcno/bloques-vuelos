class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:index]
  def index
    @availabilities_by_user = User.includes(:availabilities).where.not(availabilities: { id: nil })

  end

  def new
        @days = Date::DAYNAMES.each_with_index.map { |name, i| [name, i] }

  end

  def create
  current_user.availabilities.destroy_all

  params[:availabilities]&.each do |day, range|
    next if range[:start_time].blank? || range[:end_time].blank?

    current_user.availabilities.create!(
      day: day.to_i,
      start_time: range[:start_time],
      end_time: range[:end_time]
    )
  end

  redirect_to availabilities_path, notice: "Disponibilidad guardada con éxito."
end


def destroy_by_user
  user = User.find(params[:user_id])
  user.availabilities.destroy_all
  redirect_to availabilities_path, notice: "Disponibilidades eliminadas para #{user.name}"
end

end
