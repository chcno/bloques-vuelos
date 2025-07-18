require 'icalendar'

class FlightBlockMailer < ApplicationMailer
  default from: ENV['GMAIL_USER']

  def notify_block(flight_block)
    @flight_block = flight_block
     # Crear evento .ics
    tzid = "America/Panama"  # GMT-5

cal = Icalendar::Calendar.new
cal.timezone do |t|
  t.tzid = tzid
end

event = cal.event
event.dtstart     = Icalendar::Values::DateTime.new(@flight_block.start_time, 'tzid' => tzid)
event.dtend       = Icalendar::Values::DateTime.new(@flight_block.end_time, 'tzid' => tzid)
event.summary     = "Bloque de Vuelo"
event.description = "Instructor: #{@flight_block.instructor.name}, Alumno: #{@flight_block.student.name}"
event.location    = "MagFlight Training"
event.uid         = SecureRandom.uuid
cal.publish

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
