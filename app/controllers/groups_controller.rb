class GroupsController < ApplicationController

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate
    @recommended = Request.where(isRecommended: true)
    @accepted
    Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").find_each do |request|
      @accepted = @accepted+request
    end
  end

  #Methods, apartir de aqui solo metodos privados
  private
  def sendToGroup()
  end

end
