class FlightBlock < ApplicationRecord
  belongs_to :aircraft
  belongs_to :instructor, class_name: "User", optional: true
  belongs_to :safety, class_name: "User", optional: true
  belongs_to :student, class_name: "User", optional: true
  belongs_to :student2, class_name: "User", optional: true
  validate :validate_flight_type

  validate :no_overlaps
  validate :airplane_not_in_maintenance


 STATUSES = ["Programado", "Realizado", "Cancelado", "No Show"]

  validates :status, inclusion: { in: STATUSES }, allow_nil: true
  def no_overlaps
    overlapping_aircraft = FlightBlock
      .where(aircraft_id: aircraft_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    if overlapping_aircraft.exists?
      errors.add(:base, "El avión está ocupado en ese horario.")
    end

     if instructor_id.present? && flight_type != 'compartido' # quita esta condición si no aplica
    overlapping_instructor = FlightBlock
      .where(instructor_id: instructor_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    errors.add(:base, "El instructor está ocupado en ese horario.") if overlapping_instructor.exists?
  end

    overlapping_student = FlightBlock
      .where(student_id: student_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    if overlapping_student.exists?
      errors.add(:base, "El estudiante está ocupado en ese horario.")
    end
  end

   

    def as_calendar_event(current_user)
      #title_text = if cancel_reason.present?
       # "CANCELADO - #{aircraft.identifier} - #{instructor&.name} / #{student&.name}"
      #else
     #   "#{aircraft.identifier} - #{instructor&.name} / #{student&.name}"
    #  end

     is_mine = [instructor_id, student_id, student2_id, safety_id].compact.include?(current_user.id)

  color_class =
    if cancel_reason.present?
      "fc-red"
    elsif is_mine
      "fc-green"
    else
      "fc-default"
    end

  
  
 base_title = case flight_type
               when "instruccion"
                 "#{aircraft.identifier} - #{instructor&.name} / #{student&.name}"
               when "safety"
                 "SAFETY - #{aircraft.identifier} - #{safety&.name} / #{student&.name}"
               when "compartido"
                 "COMPARTIDO - #{aircraft.identifier} - #{student&.name} / #{student2&.name}"
               when "prueba_acc"
                 "PRUEBA ACC - #{aircraft.identifier} - #{student&.name}"
               else
                 "#{aircraft.identifier}"
               end

  title_text = if cancel_reason.present?
    "CANCELADO - #{base_title}"
  else
    base_title
  end

      {
        id: id,
        title: title_text,
        start: start_time.iso8601,
        end: end_time.iso8601,
        notes: notes,
        className: color_class,

        #color: cancel_reason.present? ? "#EF4444" : "#6366f1",
        extendedProps: {
          cancel_reason: cancel_reason,
          notes: notes,  
          assigned_user_ids: [
            instructor_id,
            student_id,
            student2_id,
            safety_id
          ].compact
        }
      }
    end


    def airplane_not_in_maintenance
      overlapping_maintenance = Maintenance.where(aircraft_id: aircraft_id)
        .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)
      if overlapping_maintenance.exists?
        errors.add(:base, "Este avión está en mantenimiento en ese horario.")
      end
    end

#Validacines

def validate_flight_type
  case flight_type
  when "instruccion"
    errors.add(:instructor_id, "es obligatorio") if instructor_id.blank?
   # errors.add(:student_id, "es obligatorio") if student_id.blank?
  when "safety"
    errors.add(:safety_id, "es obligatorio") if safety_id.blank?
    errors.add(:student_id, "es obligatorio") if student_id.blank?
  when "compartido"
    errors.add(:student_id, "es obligatorio") if student_id.blank?
    errors.add(:student2_id, "es obligatorio") if student2_id.blank?
    if student_id == student2_id
      errors.add(:student2_id, "debe ser diferente del primer estudiante.")
    end
  when "prueba_acc"
    errors.add(:student_id, "es obligatorio") if student_id.blank?
  end
end



end



