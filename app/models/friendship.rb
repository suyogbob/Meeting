class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :state, presence: true, inclusion: { in: ['accepted', 'pending', 'requested'], message: 'is not included in the list' }
  validates :friend, uniqueness: { scope: :user }
  validate :user_cannot_be_friend

  private

  def user_cannot_be_friend
    errors.add(:user, 'cannot friend itself') if user == friend
  end
end
