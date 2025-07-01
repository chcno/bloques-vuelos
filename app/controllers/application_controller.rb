class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :check_pending_user

  private

  def check_pending_user
    if user_signed_in? && current_user.pending?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Tu cuenta está pendiente de aprobación. Contacta a Nicole."
    end
  end
end
