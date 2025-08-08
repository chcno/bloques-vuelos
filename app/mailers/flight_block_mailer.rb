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
      inst_name   = @flight_block.instructor&.name || "Sin instructor"
    safety_name = @flight_block.safety&.name
    students    = [@flight_block.student&.name, @flight_block.student2&.name].compact
    students_s  = students.any? ? students.join(" / ") : "Sin alumnos"

    desc_parts = []
    desc_parts << "Instructor: #{inst_name}"
    desc_parts << "Safety: #{safety_name}" if safety_name.present?
    desc_parts << "Alumno(s): #{students_s}"

    event.description = desc_parts.join(", ")
    event.location    = "MagFlight Training"
    event.uid         = SecureRandom.uuid

    cal.publish

      attachments["bloque_vuelo.ics"] = {
        mime_type: 'text/calendar',
        content: cal.to_ical
      }
    emails = []

    emails << @flight_block.instructor.email if @flight_block.instructor.present?
    emails << @flight_block.student.email if @flight_block.student.present?
    emails << @flight_block.student2.email if @flight_block.student2.present?
    emails << @flight_block.safety.email if @flight_block.safety.present?

    mail(
      to: emails,
      subject: "Nuevo Bloque de Vuelo Asignado"
    )
  end
end
