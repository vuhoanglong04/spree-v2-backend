class ProductImage < ApplicationRecord
  belongs_to :product
  before_destroy :delete_image

  private
  def delete_image
    S3UploadService.delete_by_url(self.url)
  end
end
