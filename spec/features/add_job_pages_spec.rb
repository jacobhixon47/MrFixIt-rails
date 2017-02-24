require 'rails_helper'

describe "post a job" do
  it "allows a basic authenticated user to post a job" do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit new_job_path
    fill_in 'Title', :with => 'Fix the sink'
    fill_in 'Description', :with => 'Sink has been leaking for 10 days now. Need fixed ASAP.'
    click_on 'Create Job'
    expect(page).to have_content 'job was posted successfully'
  end

  it "redirects to jobs page if worker signed in" do
    worker = FactoryGirl.create(:worker)
    login_as(worker, :scope => :worker)
    visit new_job_path
    expect(page).to have_content 'currently logged in as a worker'
  end

  it "redirects to signup if no user signed in" do
    visit new_job_path
    expect(page).to have_content 'must be signed in as an employer'
  end

  it "redirects to new job page if job cannot be saved" do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit new_job_path
    fill_in 'Title', :with => 'Fix the sink'
    click_on 'Create Job'
    expect(page).to have_content 'Please try again'
  end
end
