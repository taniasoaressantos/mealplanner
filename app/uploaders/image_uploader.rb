class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def extension_whitelist
    %w[bmp gif jpg jpeg png]
  end
end
