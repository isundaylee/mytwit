module TweetsHelper
  def html_codify(content)
    content = h(content)
    content.gsub! /(http:\/\/[^\s]*)/i, '<a href="\1">\1</a>'
    content.gsub! /##([0-9]*)##/i do |id|
      nid = /^##([0-9]*)##\$*/.match(id)[1].to_i
      logger.debug '------- NID is: ' + nid.to_s
      begin
        user = User.find(nid)
        link_to '@' + user.name, show_timeline_path(user)
      rescue
        link_to '@Nobody', '#'
      end
    end
    content.html_safe
  end
end
