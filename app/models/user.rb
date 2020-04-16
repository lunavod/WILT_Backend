require 'digest'
require 'securerandom'

class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  include Rails.application.routes.url_helpers

  has_one_attached :avatar

  has_many :sessions, dependent: :delete_all
  has_many :posts, class_name: 'Post', foreign_key: 'creator_id', dependent: :delete_all

  validates :username, presence: true, length: {
    in: 3..20
  }, format: { with: /\A[a-zA-Z0-9_\-\.]+\z/ }, uniqueness: true

  validates :email, presence: true, format: {
    with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  }, uniqueness: true

  validates :password, presence: true, length: {
    minimum: 8
  }

  before_save :set_password_hash, if: proc { |u| u.password_changed? }
  before_save :sanitize_description

  def as_json(*)
    super.except('password', 'password_salt', 'updated_at')
  end

  def create_hash(s)
    Digest::SHA256.hexdigest password_salt + s
  end

  def check_password(s)
    return nil unless s.instance_of? String

    create_hash(s) == password
  end

  private

  def set_password_hash
    self.password_salt = SecureRandom.hex
    self.password = create_hash(password)
  end

  def avatar_url
    unless self.avatar.attached?
      return nil
    end
    variant = self.avatar.variant(combine_options: {gravity: 'center', resize: '160x160^', extent: '160x160'})
    return rails_representation_url(variant.processed, only_path: true)
  end

  def attributes
    {'username' => nil, 'email' => nil, 'id' => nil, 'created_at' => nil, 'description' => nil, 'original_description' => nil, 'avatar_url' => nil}
  end

  def sanitize_description
    sanitizer = Rails::Html::SafeListSanitizer.new
    self.description = sanitizer.sanitize(self.description, tags: %w(b, u, s, h1, h2, blockquote, span, a), attributes: %w(href, class, target))
  end
end
