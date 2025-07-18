require 'icalendar'

class FlightBlockMailer < ApplicationMailer
  default from: ENV['GMAIL_USER']

  def notify_block(flight_block)
    @flight_block = flight_block
     # Crear evento .ics
    cal = Icalendar::Calendar.new
    event = cal.event
    event.dtstart     = @flight_block.start_time
    event.dtend       = @flight_block.end_time
    event.summary     = "Bloque de Vuelo"
    event.description = "Instructor: #{@flight_block.instructor.name}, Alumno: #{@flight_block.student.name}"
    event.location    = "MagFlight Training"
    event.uid         = SecureRandom.uuid
    cal.publish

    # Adjuntar el archivo .ics
    attachments["bloque_vuelo.ics"] = {
      mime_type: 'text/calendar',
      content: cal.to_ical
    }

    mail(
      to: [@flight_block.instructor.email, @flight_block.student.email],
      subject: "Nuevo Bloque de Vuelo Asignado"
    )
  end
end
