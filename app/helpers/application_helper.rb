module ApplicationHelper
  include Pagy::Frontend

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, request.query_parameters.merge(sort: column, direction: direction), class: css_class
  end
end
