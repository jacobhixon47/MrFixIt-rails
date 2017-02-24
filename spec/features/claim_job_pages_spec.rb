require 'rails_helper'

describe "claim a job path" do
  job = FactoryGirl.create(:job)
  it "allows a worker to claim a job" do
    worker = FactoryGirl.create(:worker)
    login_as(worker, :scope => :worker)
    visit job_path(job)
    click_on 'click here to claim it now'
    expect(page).to have_content 'successfully claimed this job'
  end

  it "redirects if user signed in" do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit job_path(job)
    click_on 'click here to claim it now'
    expect(page).to have_content 'must have a worker account'
  end

  it "redirects if no user or worker signed in" do
    visit job_path(job)
    click_on 'click here to claim it now'
    expect(page).to have_content 'must have a worker account'
  end
end
