class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_enrolled_in_current_course, only: [:show]

  def show
  end

  private

  helper_method :current_lesson
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  def require_enrolled_in_current_course
    unless current_user.enrolled_in?(current_lesson.section.course)
      redirect_to current_lesson.section.course, alert: 'Not enrolled in course, enroll to view content'
    end

  end


end
