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
  
  notes = params[:availabilities][:notes]
  errores = []

  params[:availabilities]&.each do |day, range|
    next if range["start_time"].blank? || range["end_time"].blank?

    availability = current_user.availabilities.create!(
      day: day.to_i,
      start_time: range["start_time"],
      end_time: range["end_time"],
      notes: notes

    )
      errores << availability unless availability.save

  end

 if errores.any?
    flash.now[:alert] = "Debes completar el campo de notas"
    render :new # o donde esté el formulario
  else
    redirect_to availabilities_path, notice: "Disponibilidad actualizada con éxito."
  end

end


def destroy_by_user
  user = User.find(params[:user_id])
  user.availabilities.destroy_all
  redirect_to availabilities_path, notice: "Disponibilidades eliminadas para #{user.name}"
end

end
