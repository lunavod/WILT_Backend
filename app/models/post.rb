class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  before_save :sanitize_text

  default_scope { order('id DESC') }

  def as_json(options = nil)
    super({include: :creator})
  end

  def sanitize_text
    sanitizer = Rails::Html::SafeListSanitizer.new
    self.text = sanitizer.sanitize(self.text, tags: %w(b, u, s, h1, h2, blockquote, span, a), attributes: %w(href, class, target))
  end

end
