require "mini_magick"

class EarthquakeImageGenerator
  attr_reader :earthquake, :image_path

  def initialize(earthquake:, output_path: nil, width: 150, height: 150)
    @earthquake = earthquake
    @width = width
    @height = height
    @output_path = output_path || Rails.root.join("tmp", "earthquake_#{earthquake.id}.png")
    @image_path = @output_path
  end

  def generate
    magnitude = earthquake.magnitude
    depth = earthquake.depth_km || 0

    # centralized
    x = (@width / 2).to_i
    y = (@height / 2).to_i

    # assuming a max of 700km in depth
    max_depth = 700.0
    normalized_depth = (depth.clamp(0, max_depth) / max_depth).to_f
    brightness = (normalized_depth * 255).to_i.clamp(50, 255) # Clamp to ensure visibility
    fill_color = "rgb(#{brightness},#{brightness},#{brightness})"

    radius = (magnitude * 5).to_i
    radius = [ radius, 3 ].max

    command = [
      "magick",
      "-size", "#{@width}x#{@height}",
      "xc:white",
      "-fill", fill_color,
      "-draw", "circle #{x},#{y} #{x + radius},#{y}",
      @output_path.to_s
    ]

    system(*command)

    @output_path
  end
end
