# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: [:approve, :edit, :update]
    before_action :require_admin!

    def index
            #  @users = User.where.not(role: "pending")
            #@users = User.all
            @users = if params[:query].present?
          User.where("name ILIKE ? OR email ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
        else
          User.all
        end

        respond_to do |format|
          format.html # para carga inicial
          format.turbo_stream do
            render partial: "users_table_body", locals: { users: @users }
          end
        end
    end

    def pending
      @pending_users = User.where(role: "pending")
    end

   def approve
        if @user.update(role: params[:user][:role])
            redirect_to admin_users_path, notice: "Usuario aprobado correctamente."
        else
            redirect_to admin_users_path, alert: "Error al aprobar usuario."
        end
    end


    def edit
      # Para el paso 2 (editar perfil)
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "Usuario actualizado."
      else
        render :edit
      end
    end

        def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to admin_users_path, notice: "Usuario eliminado correctamente."
        end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :role, :status)
    end
  end
end
