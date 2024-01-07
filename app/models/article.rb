class Article < ApplicationRecord
    has_many :article_tags
    has_many :tags, through: :article_tags

    before_save :set_slug

    private

    def set_slug
      self.slug = title.parameterize if title
    end
end