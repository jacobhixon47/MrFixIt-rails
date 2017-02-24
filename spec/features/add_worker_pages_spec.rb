require 'rails_helper'

describe "creates a worker and logs them in" do
  it "creates a worker account and logs in new account" do
    visit new_worker_registration_path
    fill_in 'Email', :with => 'joedirt25@nascar.com'
    fill_in 'Password', :with => 'nascar12345'
    fill_in 'Password confirmation', :with => 'nascar12345'
    click_on 'Sign up'
    expect(page).to have_content 'signed up successfully'
    expect(page).to have_content "You're signed into"
  end
  
  it "redirects to profile if worker signed in already" do
    worker = FactoryGirl.create(:worker)
    login_as(worker, :scope => :worker)
    visit new_worker_path
    expect(page).to have_content 'already logged into'
  end

  it "signs out a signed-in basic user" do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit new_worker_path
    expect(page).to have_content 'Log In as Employer'
  end

  it "takes non-logged-in users to registration page" do
    visit new_worker_path
    expect(page).to have_content 'Sign up'
  end
end
