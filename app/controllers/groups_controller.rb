class GroupsController < ApplicationController

  #Variables globales
  $acceptedM
  $acceptedV

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate
    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(300)
    sendToTurn
  end

  #Methods, apartir de aqui solo metodos privados
=begin
  private
  def sendToGroup(accepted)
  end
=end

  private
  def sendToTurn
    turn = true
    #Turno matutino
    $acceptedM = @accepted.collect do |student|
      if turn
        student
        turn = false
      else
        turn = true
      end #Termina if
    end #Termina metodo collect

    #Turno Vespertino
    $acceptedV = @accepted.collect do |student|
      if turn
        turn = false
      else
        student
        turn = true
      end #Termina if
    end #Termina metodo collect

  end #Termina metodo sendToTurn

=begin #Este bloque no sirve :()
  private
  def isFool(speciality turn)
    @speciality = ""
    case speciality

    when 1
      @speciality = "Pogra"
    when 2
      @speciality = "Admi"
    when 3
      @speciality = "Electro"
    when 4
      @speciality = "Conta"
    when 5
      @speciality = "Meca"

    end

    case turn
    when 0
      @speciality = "#{@speciality}MA"
      if()
  end
=end

end
