# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def article_by_permalink(permalink)
      arts = Article.where(:permalink=>permalink)
      arts.length.should == 1
      arts[0]
  end

  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    
    when /^the admin home page$/
      '/admin'

    when /^the new article page$/
      '/admin/content/new'

    when /^the edit page for an article I wrote$/
      a = Article.find_by_author(@current_user)
      "/admin/content/edit/#{a.id}"

    when /^the public page for the \"(.*)\" article$/
      art = article_by_permalink($1)
      #debugger
      art.permalink_url(anchor=nil, only_path=true)

    # the comments page for the "peter-piper" article
    when /^the comments page for the \"(.*)\" article$/
      art = article_by_permalink($1)
      #debugger
      "/comments?article_id=#{art.id}"


    when /^the edit page for the \"(.*)\" article$/
      art = article_by_permalink($1)
      "/admin/content/edit/#{art.id}"

    when /^the edit page for article with id \"(.*)\"$/
      "/admin/content/edit/#{$1}"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
