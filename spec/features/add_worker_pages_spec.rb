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
end
