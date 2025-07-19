class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:contacto]

    def contacto

    end

end