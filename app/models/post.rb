class Post < ApplicationRecord
  require 'sanitize'

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  before_save :sanitize_text

  default_scope { order('id DESC') }

  validate :sanitized_text

  def as_json(options = nil)
    super({include: :creator})
  end

  def sanitize_text
    sanitizer = Rails::Html::SafeListSanitizer.new
    self.text = Sanitize.fragment(self.text,
      :elements => ['blockquote', 'span', 'b', 'u', 's', 'i', 'a', 'h1', 'h2', 'br'],

      :attributes => {
        'a'    => ['href', 'title'],
        'span' => ['class']
      },

      :protocols => {
        'a' => {'href' => ['http', 'https', 'mailto']}
      }
    )
  end

  def sanitized_text
    sanitized = Sanitize.fragment(self.text,
      :elements => ['blockquote', 'span', 'b', 'u', 's', 'i', 'a', 'h1', 'h2'],

      :attributes => {
        'a'    => ['href', 'title'],
        'span' => ['class']
      },

      :protocols => {
        'a' => {'href' => ['http', 'https', 'mailto']}
      }
    )

    if sanitized.length < 10
      errors.add(:text, 'too short (minimum length is 10)')
    end
  end

end
