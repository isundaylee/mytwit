module TweetsHelper
  def html_codify(content)
    content = h(content)
    # Translating raw URLs
    content.gsub! /(http:\/\/[^\s]*)/i, '<a href="\1">\1</a>'
    # Translating user mentions
    content.gsub! /##([0-9]*)##/i do |id|
      nid = /^##([0-9]*)##\$*/.match(id)[1].to_i
      begin
        user = User.find(nid)
        link_to '@' + user.name, show_timeline_path(user)
      rescue
        link_to '@Nobody', '#'
      end
    end
    # Translating shorturls
    content.gsub! /::([0-9a-f]*)::/i do |url|
      abbrev = /^::([0-9a-f]*)::$/i.match(url)[1]
      fullurl = goto_shorturl_url(abbrev)
      link_to fullurl, fullurl
    end
    content.html_safe
  end
end
