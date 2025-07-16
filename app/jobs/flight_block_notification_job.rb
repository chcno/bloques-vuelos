class FlightBlockNotificationJob < ApplicationJob
  queue_as :default

  def perform(flight_block_id)
    block = FlightBlock.find_by(id: flight_block_id)

    return unless block

    # Evitar enviar notificaciones a bloques inválidos
    if block.cancel_reason.present?
      Rails.logger.info "⛔ No se envía mail. Bloque cancelado."
      return
    end

    if block.invalid?
      Rails.logger.info "⛔ No se envía mail. Bloque con errores: #{block.errors.full_messages}"
      return
    end

    # No enviar dos veces
    if block.last_notified_at.present?
      Rails.logger.info "✅ Mail ya enviado previamente para bloque #{block.id}"
      return
    end

    # ¡aquí sí envías el correo!
    FlightBlockMailer.notify_block(block).deliver_now

    block.update!(last_notified_at: Time.current)
  end
end
