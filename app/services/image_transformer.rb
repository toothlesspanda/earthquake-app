# app/services/image_transformer.rb
require "mini_magick"
require "open-uri"

class ImageTransformer
  attr_reader :image_path, :processed_path

  def initialize(input_path_or_url)
    @image_path = download_if_url(input_path_or_url)
  end

  # Process image to a simple heightmap or other transformation
  # transformation: :grayscale (default), :edges, etc.
  # resize: optional, square size for heightmap
  def process(transformation: :grayscale, resize: 256)
    sleep(10)
    image = MiniMagick::Image.open(@image_path)
    image.resize "#{resize}x#{resize}"

    case transformation
    when :edges
      image.colorspace "Gray"
      image.edge "1"
    else
      image.colorspace "Gray"
    end

    final_output_path = Rails.root.join("tmp", "processed_#{SecureRandom.hex(6)}.png")
    image.write(final_output_path)

    final_output_path
  end

  private

  def download_if_url(input)
    if input =~ URI::DEFAULT_PARSER.make_regexp
      safe_input = input.gsub("\\", "")
      tempfile = Tempfile.new([ "image", ".png" ], binmode: true)
      URI.open(safe_input) { |f| tempfile.write(f.read) }
      tempfile.rewind
      tempfile.path
    else
      input
    end
  end
end
