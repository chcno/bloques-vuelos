class FlightBlock < ApplicationRecord
  belongs_to :aircraft
  belongs_to :instructor, class_name: "User"
  belongs_to :student, class_name: "User"

  validate :no_overlaps

  def no_overlaps
    overlapping_aircraft = FlightBlock
      .where(aircraft_id: aircraft_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    if overlapping_aircraft.exists?
      errors.add(:base, "El avión está ocupado en ese horario.")
    end

    overlapping_instructor = FlightBlock
      .where(instructor_id: instructor_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    if overlapping_instructor.exists?
      errors.add(:base, "El instructor está ocupado en ese horario.")
    end

    overlapping_student = FlightBlock
      .where(student_id: student_id)
      .where.not(id: id)
      .where("(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time)

    if overlapping_student.exists?
      errors.add(:base, "El estudiante está ocupado en ese horario.")
    end
  end
end



