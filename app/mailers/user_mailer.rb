class UserMailer < ApplicationMailer
  def block_canceled_due_to_maintenance(block)
    @block = block
    @aircraft = block.aircraft

    recipients = []
    recipients << block.instructor.email if block.instructor.present?
    recipients << block.student.email if block.student.present?
    recipients.uniq! # ✅ elimina duplicados

    if recipients.any?
      mail(
        to: recipients,
        subject: "Tu bloque ha sido cancelado por mantenimiento"
      )
    end
  end
end
