require 'securerandom'

class Invite < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', optional: true

  before_save :set_code
  before_save :sanitize_description

  def attributes
    {'id' => nil, 'code' => nil, 'description' => nil, 'created_at' => nil, 'updated_at' => nil, 'creator' => nil, 'user' => nil}
  end

  def set_code
    return unless self.code.nil?
    self.code = SecureRandom.hex
  end

  def sanitize_description
    sanitizer = Rails::Html::FullSanitizer.new
    self.description = Sanitize.fragment(self.description)
  end
end
