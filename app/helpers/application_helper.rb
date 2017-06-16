module ApplicationHelper
  def title(name)
    name.capitalize.pluralize
  end

  def first_name(name)
    name.gsub(/\s\w*/, '')
  end
end
