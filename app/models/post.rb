class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :content, presence: true
  validate :no_election_words

  scope :recent_first, -> { order(created_at: :desc) }
  scope :by_username, ->(username) { joins(:user).where(users: { username: username }) }

  private

  def no_election_words
    forbidden_words = ["Trump", "Harris"]
    if content.present? && forbidden_words.any? { |word| content.include?(word) }
      errors.add(:content, "contains forbidden words.")
    end
  end
end
