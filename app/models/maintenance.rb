class Maintenance < ApplicationRecord
  belongs_to :aircraft

  validates :start_time, :end_time, presence: true
  validate :end_after_start
    def as_calendar_event
        {
          id: "maintenance-#{id}",
          title: "Mantenimiento - #{aircraft.identifier}",
          start: start_time.iso8601,
          end: end_time.iso8601,
          color: "#DC2626", # rojo,
           editable: false
        }
      end
  private

  def end_after_start
    return if start_time.blank? || end_time.blank?
    if end_time <= start_time
      errors.add(:end_time, "debe ser posterior a la hora de inicio")
    end
  end
end
