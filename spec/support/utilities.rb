include ApplicationHelper

def sign_in(user, options = {})
  if options[:no_capybara]
    # Signin when not using capybara
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
  end
end

def fill_valid_signup_details
  fill_in "First name", with: "Chandan"
  fill_in "Last name", with: "Kumar"
  fill_in "Email", with: "chandan.jhun@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end
