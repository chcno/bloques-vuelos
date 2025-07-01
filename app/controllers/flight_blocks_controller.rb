class FlightBlocksController < ApplicationController
  before_action :set_flight_block, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!

  def index
    @flight_blocks = FlightBlock.all.includes(:aircraft, :instructor, :student).order(:start_time)
  end

  def new
    @flight_block = FlightBlock.new
  end
  def show
  end

  def create
  @flight_block = FlightBlock.new(flight_block_params)

  if @flight_block.save
    begin
      puts "🔴 LLAMANDO AL MAILER 🔴"
      FlightBlockMailer.notify_block(@flight_block).deliver_now
      flash[:notice] = "Bloque creado y correo enviado."
    rescue => e
      Rails.logger.error "ERROR ENVIANDO MAIL: #{e.message}"
      flash[:alert] = "ERROR ENVIANDO MAIL: #{e.message}"
    end

    redirect_to flight_blocks_path
  else
    render :new
  end
end


  def edit
  end

  def update
    if @flight_block.update(flight_block_params)
      # Aquí podrías mandar email de actualización
        FlightBlockMailer.notify_block(@flight_block).deliver_now

      redirect_to flight_blocks_path, notice: "Bloque de vuelo actualizado."
    else
      render :edit
    end
  end

  def destroy
    @flight_block.destroy
    redirect_to flight_blocks_path, notice: "Bloque de vuelo eliminado."
  end

  private

  def set_flight_block
    @flight_block = FlightBlock.find(params[:id])
  end

  def flight_block_params
    params.require(:flight_block).permit(
      :aircraft_id,
      :instructor_id,
      :student_id,
      :start_time,
      :end_time,
      :notes
    )
  end

  def authorize_admin!
    redirect_to root_path, alert: "No autorizado" unless current_user&.admin?
  end
end
