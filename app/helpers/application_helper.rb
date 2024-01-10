module ApplicationHelper
  def page_title
    title = "BlueTicket"
    title = @page_title + "-" + title if @page_title
    title
  end

  def menu_link_to(text, path, options = {})
    content_tag :li do
      condition = options[:method] || !current_page?(path)

      link_to_if(condition, text, path, options) do
        content_tag(:span, text)
      end
    end
  end

  def seat_class_map
    { "economy" => "エコノミー", "business" => "ビジネス", "first" => "ファースト" }
  end

  def change_language(language)
    request_params = request.query_parameters
    request_params[:locale] = language
    url_for(request_params)
  end
end
