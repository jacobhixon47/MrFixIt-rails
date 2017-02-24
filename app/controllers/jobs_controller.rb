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
      flash[:alert] = 'There was a problem posting your job. Please try again.'
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if current_worker
      if @job.update(pending: true, worker_id: current_worker.id)
        respond_to do |format|
          format.html { redirect_to job_path(@job) }
          format.js
        end
      end
    elsif user_signed_in? || !user_signed_in?
      flash[:notice] = 'You must have a worker account to claim a job. Register for one using the link in the navbar above.'
      redirect_to job_path(@job)
    end
  end

  # ------ mark job as active ----------------
  def active
    @job = Job.find(params[:id])
    if worker_signed_in? && current_worker.id === @job.worker_id
      if @job.update(active: true)
        respond_to do |format|
          format.html { redirect_to job_path(@job) }
          format.js
        end
      end
    elsif user_signed_in? || !user_signed_in? && !worker_signed_in?
      flash[:notice] = 'You must have a worker account to use this feature. Register for one using the link in the navbar above.'
      redirect_to job_path(@job)
    elsif current_worker.id != @job.worker_id
      flash[:notice] = 'Someone else has already claimed this job. Please try a job that you have claimed.'
      redirect_to job_path(@job)
    end
  end

# ------ mark job as complete ----------------
  def complete
    @job = Job.find(params[:id])
    if worker_signed_in? && current_worker.id === @job.worker_id && @job.active?
      if @job.update(completed: true)
        respond_to do |format|
          format.html { redirect_to job_path(@job) }
          format.js
        end
      end
    elsif user_signed_in? || !user_signed_in? && !worker_signed_in?
      flash[:notice] = 'You must have a worker account to use this feature. Register for one using the link in the navbar above.'
      redirect_to job_path(@job)
    elsif current_worker.id != @job.worker_id
      flash[:notice] = 'Someone else has already claimed this job. Please try a job that you have claimed.'
      redirect_to job_path(@job)
    elsif !@job.active?
      flash[:notice] = 'This job has not been activated yet and therefore cannot be marked as complete.'
      redirect_to job_path(@job)
    end
  end

private
  def job_params
    params.require(:job).permit(:title, :description)
  end
end
