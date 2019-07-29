class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:create]
  before_action :require_authorized_for_current_section, only: [:update]
  skip_before_action :verify_authenticity_token
  #This was the only suggested fix I could find that would fix error received when trying to reorder list items. I got this line from the following stackoverflow post: https://stackoverflow.com/questions/5669322/turn-off-csrf-token-in-rails-3


  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
    render plain: 'ok!'
  end

  private

  def require_authorized_for_current_section
    if current_section.course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  def current_section
    @current_section ||= Section.find(params[:id])
  end

  def require_authorized_for_current_course
    if current_course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  helper_method :current_course
  def current_course
    if params[:course_id]
      @current_course ||= Course.find(params[:course_id])
    else
      current_section.course
    end
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end
end