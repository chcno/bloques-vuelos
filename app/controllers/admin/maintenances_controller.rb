module Admin
  class MaintenancesController < ApplicationController
      before_action :require_admin!

    def new
      @maintenance = Maintenance.new
    end

    def create
      @maintenance = Maintenance.new(maintenance_params)
      if @maintenance.save
        cancel_blocks(@maintenance)

        redirect_to admin_users_path, notice: "Mantenimiento creado y bloques afectados cancelados."
      else
        render :new
      end
    end
    def index
        @maintenances = Maintenance.all
    end
        
    def destroy
           @maintenance = Maintenance.find(params[:id])
        @maintenance.destroy
        redirect_to admin_maintenances_path, notice: "Mantenimiento eliminado correctamente."
    end


    private

    def maintenance_params
      params.require(:maintenance).permit(:aircraft_id, :start_time, :end_time, :reason)
    end

       def cancel_blocks(maintenance)
            affected_blocks = FlightBlock
                .where(aircraft_id: maintenance.aircraft_id)
                .where("(start_time, end_time) OVERLAPS (?, ?)", maintenance.start_time, maintenance.end_time)

            Rails.logger.info "🚀 Se encontraron #{affected_blocks.count} bloques solapados."

            affected_blocks.each do |block|
                block.update_columns(
                cancel_reason: "Cancelado por mantenimiento del #{maintenance.start_time.strftime("%d/%m/%Y %H:%M")}"
                )
                Rails.logger.info "⛔ Bloque #{block.id} marcado como cancelado."
                UserMailer.block_canceled_due_to_maintenance(block).deliver_later
            end
            end


  end
end
