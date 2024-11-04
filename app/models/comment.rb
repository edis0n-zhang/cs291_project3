class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true
  validate :no_election_words

  private

  def no_election_words
    forbidden_words = ["Trump", "Harris"]
    if content.present? && forbidden_words.any? { |word| content.include?(word) }
      errors.add(:content, "contains forbidden words.")
    end
  end
end
