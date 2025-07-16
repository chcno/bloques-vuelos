class NoShowMailer < ApplicationMailer
  def notify_student(flight_block)
    @flight_block = flight_block

    to_emails = []
    to_emails << @flight_block.student.email if @flight_block.student.present?
    to_emails << @flight_block.student2.email if @flight_block.student2.present?

    return if to_emails.empty?

    mail(
      to: to_emails,
      subject: "Aviso: NO SHOW en tu vuelo programado"
    )
  end
end