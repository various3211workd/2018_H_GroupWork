class CommentImageUploader < CarrierWave::Uploader::Base
  def default_url(*args)
    "/images/" + [version_name, "noimage.png"].compact.join('_')
  end
  
  storage :file

  def store_dir
    'uploads/comment'
  end

  include CarrierWave::RMagick

  process :resize_to_limit => [400, 400]
  process :convert => 'jpg'
  
  version :thumb do
    process :resize_to_limit => [100, 100]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end
  
  def filename
    time = Time.now
    name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
    name.downcase
  end

end