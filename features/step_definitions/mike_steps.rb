Given /the following articles exist/ do |content_table|
  content_table.hashes.each do |article|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    user = User.find_by_login(article[:author])
    #user.should be_valid
    a = Article.create(
      :author     => user.id,
      :user       => user,
      :title      => article[:title],
      :body       => article[:body],
      :permalink  => article[:permalink]
    )
    a.comments.push(Comment.new(:body=>article[:comment], :author=>'cucumber'))
    #a.save!
  end
end

Given /^I am not an administrator$/ do
  @current_user.admin?.should be_false
end

Given /^I am an administrator$/ do
  @current_user.admin?.should be_true
end

And /^I am logged in as a publisher$/ do
  visit '/accounts/login'
  fill_in 'user_login', :with => @publisher.login
  fill_in 'user_password', :with => @everyones_passwd
  click_button 'Login'
  @current_user = @publisher
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
  @current_user.admin?.should be_false
end

#   I fill in "merge_with" with the id of the "peter-piper" article
When /^I fill in "(.*?)" with the id of the "(.*?)" article$/ do |field, permalink|
      arts = Article.where(:permalink=>permalink)
      arts.length.should == 1
      art = arts[0]
      fill_in(field, :with=>art.id)
end
