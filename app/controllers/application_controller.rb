class ApplicationController < ActionController::Base
before_action :authenticate_user!
# this code added made the index page require a sign in to view
  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    redirect_to instructor_course_path(@course)
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :cost)
  end
end
