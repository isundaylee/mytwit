module ApplicationHelper
  
  def html_codify(content)
    content = h(content)
    content.gsub! /(http:\/\/[^\s]*)/i, '<a href="\1">\1</a>'
    content.html_safe
  end
  
end
