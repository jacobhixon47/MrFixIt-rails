require 'rails_helper'

describe "mark a job as active path", js: true do
  scenario "allows a worker to activate a job" do
    worker = FactoryGirl.create(:worker)
    login_as(worker, :scope => :worker)
    job = FactoryGirl.create(:job, :worker_id => worker.id)
    visit job_path(job)
    click_on 'mark job as active'
    expect(page).to have_content 'You have marked this job as active'
  end
  it "redirects if wrong worker signed in" do
    worker = FactoryGirl.create(:worker)
    worker2 = FactoryGirl.create(:worker, :email => 'bobbyboucher@sclsu.edu', :password => 'muddogs12345')
    login_as(worker, :scope => :worker)
    job = FactoryGirl.create(:job, :worker_id => worker2.id, :pending => true)
    visit active_path(job)
    expect(page).to have_content 'Someone else has already claimed this job'
  end

  it "redirects if basic user signed in" do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    job = FactoryGirl.create(:job)
    visit active_path(job)
    expect(page).to have_content 'must have a worker account'
  end

  it "redirects if no user signed in" do
    job = FactoryGirl.create(:job)
    visit active_path(job)
    expect(page).to have_content 'must have a worker account'
  end
end
