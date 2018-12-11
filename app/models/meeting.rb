class Meeting < ApplicationRecord
  # require 'google/apis/calendar_v3'

  belongs_to :user
  belongs_to :friend, class_name: 'User'
  belongs_to :location

  validates :user, presence: true
  validates :friend, uniqueness: { scope: :user }
  validates :location, presence: true
  validates :agenda, presence: true #inclusion: { in: ['work', 'social'], message: 'is not included in the list' }
  validates :state, presence: true #inclusion: { in: ['planned', 'completed', 'cancelled'], message: 'is not included in the list' }
  validate :user_cannot_be_friend

  private

  def user_cannot_be_friend
    errors.add(:user, 'cannot friend itself') if user == friend
  end
end
