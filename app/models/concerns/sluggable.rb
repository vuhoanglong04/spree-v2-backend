module Sluggable
  extend ActiveSupport::Concern

  included do
    before_create :generate_slug
  end

  def generate_slug
    self.slug = name.parameterize
  end
end