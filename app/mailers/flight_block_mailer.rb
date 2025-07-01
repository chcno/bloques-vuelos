class FlightBlockMailer < ApplicationMailer
  default from: ENV['GMAIL_USER']

  def notify_block(flight_block)
    @flight_block = flight_block

    mail(
      to: [@flight_block.instructor.email, @flight_block.student.email],
      subject: "Nuevo Bloque de Vuelo Asignado"
    )
  end
end
