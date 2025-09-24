class EarthquakesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    set_earthquakes
  end

  def show
   @earthquake = Earthquake.find(params[:id])
  end

  def processed_image
    @earthquake = Earthquake.find(params[:id])
    unless @earthquake.image_for_3d.attached?
      generator = EarthquakeImageGenerator.new(earthquake: @earthquake)
      output_path = generator.generate

      @earthquake.image_for_3d.attach(
        io: File.open(output_path),
        filename: "earthquake_#{@earthquake.id}.png",
        content_type: "image/png"
      )
    end

    unless @earthquake.heightmap_image.attached?
      image_data = @earthquake.image_for_3d.download
      tempfile = Tempfile.new(%w[downloaded_image .png], binmode: true)
      tempfile.write(image_data)
      tempfile.rewind
      map_path = tempfile.path

      transformer = ImageTransformer.new(map_path)
      output_path = transformer.process(transformation: :grayscale)

      @earthquake.heightmap_image.attach(
        io: File.open(output_path),
        filename: "earthquake_#{@earthquake.id}_heightmap.png",
        content_type: "image/png"
      )
    end
  end

  private

  def set_earthquakes
    base_query = Earthquake.order("#{sort_column} #{sort_direction}")

    @pagy, @pagy_earthquakes = pagy(base_query, limit: 10)
  end

  def sort_column
    Earthquake.column_names.include?(params[:sort]) ? params[:sort] : "occurred_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
