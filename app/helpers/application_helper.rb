module ApplicationHelper
  def title(name)
    name.capitalize.pluralize
  end

  def first_name(name)
    name.gsub(/\s\w*/, '')
  end

  def options_for_video_review(selected=nil)
    options_for_select([5,4,3,2,1].map {|n| [pluralize(n, "Star"), n]}, selected)
  end
end
