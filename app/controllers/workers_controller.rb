class WorkersController < ApplicationController
  def show
    @worker = current_worker
    render :show
  end

  def new
    if worker_signed_in?
      redirect_to worker_path(current_worker)
      flash[:alert] = "You're already logged into a worker account!"
    elsif current_user
      sign_out :user
      redirect_to new_worker_registration_path
    else
      redirect_to new_worker_registration_path
    end
  end

end
