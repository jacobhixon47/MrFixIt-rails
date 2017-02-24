class JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def new
    if user_signed_in?
      @job = Job.new
    elsif worker_signed_in?
      flash[:notice] = "You are currently logged in as a worker. Please log in as an employer to post jobs."
      redirect_to jobs_path
    else
      flash[:alert] = "You must be signed in as an employer to post jobs. Please create an account or sign in."
      redirect_to new_user_registration_path
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "Your job was posted successfully!"
      redirect_to jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if worker_signed_in?
      @job.update(pending: true, worker_id: current_worker.id)
      redirect_to worker_path(current_worker)
      flash[:notice] = "You've successfully claimed this job."
    elsif user_signed_in? || !user_signed_in?
      flash[:notice] = 'You must have a worker account to claim a job. Register for one using the link in the navbar above.'
      redirect_to job_path(@job)
    else
      render :show
      flash[:notice] = "Something went wrong!"
    end
  end

private

  def job_params
    params.require(:job).permit(:title, :description)
  end

end
