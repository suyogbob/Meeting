class User < ApplicationRecord
  include BCrypt
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where friendships: { state: 'accepted' } }, through: :friendships
  has_many :requested_friends, -> { where friendships: { state: 'requested' } }, through: :friendships, source: :friend
  has_many :pending_friends, -> { where friendships: { state: 'pending' } }, through: :friendships, source: :friend
  has_many :meetings
  has_many :locations, through: :meetings

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :first_name_capitalized, :last_name_capitalized, :email_missing_symbols

  def full_name
    "#{first_name} #{last_name}"
  end

  def password
    @password ||= Password.new(password_hash) unless password_hash.nil?
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def send_friend_request(friend)
    return if Friendship.exists?(user: self, friend: friend) || Friendship.exists?(user: friend, friend: self)
    friendship = Friendship.new(user: self, friend: friend, state: 'requested')
    friendship.save
    friendship2 = Friendship.new(user: friend, friend: self, state: 'pending')
    friendship2.save
  end

  def accept_friend_request(friend)
    return unless Friendship.exists?(user: self, friend: friend, state: 'pending') && Friendship.exists?(user: friend, friend: self, state: 'requested')
    friendship = Friendship.find_by(user: self, friend: friend)
    friendship.state = 'accepted'
    friendship2 = Friendship.find_by(user: friend, friend: self)
    friendship2.state = 'accepted'
    friendship.save
    friendship2.save
  end

  def delete_friend(friend)
    Friendship.find_by(user: self, friend: friend).delete if Friendship.exists?(user: self, friend: friend)
    Friendship.find_by(user: friend, friend: self).delete if Friendship.exists?(user: friend, friend: self)
  end

  private

  def first_name_capitalized
    errors.add(:first_name, 'must be capitalized') if !first_name.nil? && (first_name.capitalize != first_name)
  end

  def last_name_capitalized
    errors.add(:last_name, 'must be capitalized') if !last_name.nil? && (last_name.capitalize != last_name)
  end

  def email_missing_symbols
    errors.add(:email, "must have an '@' and a '.'") if !email.nil? && (!email.include?('@') || !email.include?('.'))
  end
end
