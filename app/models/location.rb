class Location < ApplicationRecord
  has_many :meetings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :users, through: :meetings

  validates :name, presence: true
  validates :area, presence: true, uniqueness: { scope: :name }

  def plan_meeting(user, friend, start_time, end_time, agenda)
    return if Meeting.exists?(user: user, friend: friend, start_time: start_time) || Meeting.exists?(user: friend, friend: user, start_time: start_time)
    meeting = Meeting.new(user: user, friend: friend, start_time: start, end_time: end_time, state: 'planned', location: self, agenda: agenda)
    meeting.save
  end

  def cancel_meeting(user, friend, start_time)
    Meeting.find_by(user: user, friend: friend, start_time: start_time).delete if Meeting.exists?(user: user, friend: friend, start_time: start_time)
    Meeting.find_by(user: friend, friend: user, start_time: start_time).delete if Meeting.exists?(user: friend, friend: user, start_time: start_time)
  end
end
