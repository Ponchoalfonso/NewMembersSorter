class GroupsController < ApplicationController

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate
    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(300)
    splitIntoTurns(@accepted)
  end #generate

  # # # # # # # # # # # # # # # # # # # # # # # # #
  # Methods, apartir de aqui solo metodos privados #
  # # # # # # # # # # # # # # # # # # # # # # # # #

  private
  def splitIntoTurns(accepted)

    #Creo dos variables array que contendran a los alumnos separados
    @acceptedM = Array.new
    @acceptedV = Array.new

    #Mando a los usuarios de mecanica directamente al turno vespertino\
    mecha = accepted.where(speciality: 5)
    for i in(1..mecha.length)
      @acceptedV.push(mecha.limit(1).offset(i))
    end

    #Manda a los alumnos foraneos directamente al turno matutino
    foreign = accepted.where(isForeign: true).where.not(speciality: 5)

    for i in(1..mecha.length)
      @acceptedM.push(foreign.limit(1).offset(i))
    end

    #Separamos al resto en dos grupos
    accepted = accepted.where.not(speciality: 5).where(isForeign: false)
    for i in(1..300)
      if i % 2 == 0
        @acceptedM.push(accepted.limit(1).offset(i))
      else
        @acceptedV.push(accepted.limit(1).offset(i))
      end#if
    end #for
  end #splitIntoTurns
end
