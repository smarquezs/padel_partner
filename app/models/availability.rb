class Availability < ApplicationRecord
  belongs_to :user

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  # Day of week constants for clarity
  DAYS_OF_WEEK = {
    0 => "Sunday",
    1 => "Monday", 
    2 => "Tuesday",
    3 => "Wednesday",
    4 => "Thursday",
    5 => "Friday",
    6 => "Saturday"
  }.freeze

  def day_name
    DAYS_OF_WEEK[day_of_week]
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time
    
    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
