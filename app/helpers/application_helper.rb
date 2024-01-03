module ApplicationHelper
  def page_title
    title = "BlueTicket"
    title = @page_title + "-" + title if @page_title
    title
  end
end
