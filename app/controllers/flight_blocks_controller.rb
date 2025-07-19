class FlightBlocksController < ApplicationController
  before_action :set_flight_block, only: [:show, :edit, :update, :destroy]
  #before_action :authorize_admin!,  only: [:edit, :update, :destroy]
  before_action :require_admin!, except: [:show, :index, :calendar]


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
    if @flight_block.cancel_reason.blank?
      begin
        puts "🔴 LLAMANDO AL MAILER 🔴"
        FlightBlockMailer.notify_block(@flight_block).deliver_now
        flash[:notice] = "Bloque creado y correo enviado."
      rescue => e
        Rails.logger.error "ERROR ENVIANDO MAIL: #{e.message}"
        flash[:alert] = "ERROR ENVIANDO MAIL: #{e.message}"
      end
    else
      flash[:alert] = "Bloque creado, pero fue cancelado inmediatamente por mantenimiento. No se envió correo de asignación."
    end

    redirect_to flight_blocks_path
  else
    render :new
  end
end


  def edit
  end

 # PATCH/PUT /flight_blocks/:id
  def update
    if @flight_block.update(flight_block_params)
      check_and_send_notification(@flight_block)

      respond_to do |format|
        format.json { render json: { status: "ok" } }
        format.html { redirect_to flight_blocks_path, notice: "Bloque actualizado correctamente." }
      end
    else
      respond_to do |format|
        format.json { render json: { status: "error", errors: @flight_block.errors.full_messages }, status: :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end



  def destroy
    @flight_block.destroy
    redirect_to flight_blocks_path, notice: "Bloque de vuelo eliminado."
  end


        def calendar
            @flight_blocks = FlightBlock.all
            @maintenances = Maintenance.includes(:aircraft).all

           events = @flight_blocks.map { |block| block.as_calendar_event(current_user) } +
           @maintenances.map(&:as_calendar_event)

            respond_to do |format|
                format.html
                format.json { render json: events }
            end
        end


    ##########
    #enviar correo
    #
        def check_and_send_notification(flight_block)
        changed = flight_block.previous_changes.slice("start_time", "end_time").any?

        if changed
            # 🚫 Cancela job anterior, si existe:
            if flight_block.notification_job_id.present?
            Sidekiq::ScheduledSet.new.find_job(flight_block.notification_job_id)&.delete
            end

            # ✅ Programa job para 30 min después:
            job = FlightBlockNotificationJob.set(wait: 30.minutes).perform_later(flight_block.id)

            # Guarda el job_id para poder cancelarlo si vuelve a moverse:
            flight_block.update_column(:notification_job_id, job.provider_job_id)

            Rails.logger.info "✅ Correo programado en 30 min para bloque ##{flight_block.id}"
        else
            Rails.logger.info "ℹ️ No se programa correo porque no hubo cambios en start_time o end_time."
        end
        end



  def no_show
        @flight_block = FlightBlock.find(params[:id])

@flight_block.update_column(:status, "No Show")
  if @flight_block.student.present?
    NoShowMailer.notify_student(@flight_block).deliver_later
  end

  redirect_to flight_blocks_path, notice: "Se ha registrado el NO SHOW y se notificó al estudiante."
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
      :student2_id,
     :safety_id,
     :flight_type,
      :start_time,
      :end_time,
      :notes
    )
  end

  def authorize_admin!
    redirect_to root_path, alert: "No autorizado" unless current_user&.admin?
  end
end
