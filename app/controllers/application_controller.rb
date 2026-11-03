class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized
  after_action :verify_policy_scoped, if: -> { action_name == "index" }
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def pundit_user
    resume_session&.user
  end

  def user_not_authorized(exception)
    logger.warn "403: user #{pundit_user&.id} refused #{exception.policy.class}##{exception.query} " \
                "on #{exception.record.class} #{exception.record.try(:to_param)}"
    flash.now[:alert] = "You are not allowed to do that."
    render "shared/forbidden", status: :forbidden
  end
end
