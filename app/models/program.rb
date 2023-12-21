class Program < ApplicationRecord
  #has_many :entries, dependent: :destroy
  has_many :entries, dependent: :restrict_with_exception
  has_many :applicants, through: :entries, source: :customer
  belongs_to :registrant, class_name: "StaffMember"

  scope :listing, -> {
    #order(application_start_time: :desc)
    left_outer_joins(:entries)
      .select("programs.*, count(entries.id) AS number_of_applicants")
      .group("programs.id")
      .order(application_start_time: :desc)
      .includes(:registrant)
  }

  attribute :application_start_date, :date, default: Date.today
  attribute :application_start_hour, :integer, default: 9
  attribute :application_start_minute, :integer, default: 0

  attribute :application_end_date, :date, default: Date.today
  attribute :application_end_hour, :integer, default: 17
  attribute :application_end_minute, :integer, default: 0

  validates :title, presence: true, length: { maximum: 32 }
  validates :description, presence: true, length: { maximum: 800 }
  validate :check_application_time

  validates_numericality_of  :min_number_of_participants, 
                            :max_number_of_participants,
      allow_blank: true,
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 1000

  validate :check_number_of_participants

  after_initialize :divide_application_timwe
  before_validation :restore_application_time

  DATETIME_FORMAT = "%Y-%m-%d %H:%M"

  def application_start_time_format
    application_start_time.strftime(DATETIME_FORMAT)
  end

  def application_end_time_format
    application_end_time.strftime(DATETIME_FORMAT)
  end

  def number_of_applicants
    self[:number_of_applicants] || entries.count
  end

  def registrant_name
    registrant.family_name + " " + registrant.given_name
  end

  def deletable?
    number_of_applicants == 0
  end

  private def check_application_time
    if application_start_time
      unless application_start_time >= Time.zone.local(2000,1,1)
          errors.add( :application_start_time, :after_or_equal_to )
      end
    end
    if application_start_time && application_end_time  
      unless application_end_time > application_start_time 
          errors.add( :application_end_time, :after )
      end
      unless application_end_time < application_start_time.advance(days: 90)
          errors.add( :application_end_time, :before )
      end
    end
  end

  private def check_number_of_participants
    if min_number_of_participants && max_number_of_participants 
      unless min_number_of_participants < max_number_of_participants  
        errors.add( :max_number_of_participants, :less_than_min_number )
      end
    end
  end

  private def restore_application_time
    if t = application_start_date&.in_time_zone
      self.application_start_time = t.advance(
        hours: application_start_hour,
        minutes: application_start_minute
      )
    end
    if t = application_end_date&.in_time_zone
      self.application_end_time = t.advance(
        hours: application_end_hour,
        minutes: application_end_minute
      )
    end
  end

  private def divide_application_timwe
    if application_start_time
      self.application_start_date = application_start_time.to_date 
      self.application_start_hour = application_start_time.hour 
      self.application_start_minute = application_start_time.min 
    end
    if application_end_time
      self.application_end_date = application_end_time.to_date 
      self.application_end_hour = application_end_time.hour 
      self.application_end_minute = application_end_time.min 
    end
  end

end
