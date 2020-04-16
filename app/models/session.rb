require 'securerandom'

class Session < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  before_save :set_key, if: proc { |s| s.key.blank? }

  def as_json(*)
    super.except('key', 'updated_at')
  end

  private

  def set_key
    self.key = SecureRandom.hex(32)
  end
end
