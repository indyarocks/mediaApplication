module ApplicationHelper

  # Returns full title on a per-page basis
  def full_title(page_title)
    base_title = "Media Application"
    if page_title.blank?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
