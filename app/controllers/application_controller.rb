class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  before_action :check_pending_user
  before_action :configure_permitted_parameters, if: :devise_controller?

  def require_admin!
    redirect_to root_path, alert: "No tienes permiso para acceder" unless current_user&.admin?
  end


  protected

  def configure_permitted_parameters
    # Para sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # Para editar perfil
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  private

  def check_pending_user
    if user_signed_in? && current_user.pending?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Tu cuenta está pendiente de aprobación. Contacta a Nicole."
    end
  end
end
