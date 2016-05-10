class GroupsController < ApplicationController

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate
    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(300)
    #Creo dos variables array que contendran a los alumnos separados
    @acceptedM
    @acceptedV
    @electroMA = Array.new
    @adminMA = Array.new
    @contaMA = Array.new

    splitIntoTurns(@accepted)
=begin
    @acceptedM.each do |m|
        case m.speciality
        when 1
          puts "Programacion"
        when 2
          puts"administracion"
        when 3
          puts"electronica"
        when 4
          puts"contabilidad"
        end
    end
=end
  end #generate

  # # # # # # # # # # # # # # # # # # # # # # # # #
  # Methods, apartir de aqui solo metodos privados #
  # # # # # # # # # # # # # # # # # # # # # # # # #

  private
  def splitIntoTurns(accepted)
    #Mando a los usuarios de mecanica directamente al turno vespertino\
    mecha = accepted.where(speciality: 5)
    @acceptedV = mecha.each do |m|
      m
    end

    #Manda a los alumnos foraneos directamente al turno matutino
    foreign = accepted.where(isForeign: true).where.not(speciality: 5)
    @acceptedM = foreign.each do |f|
      f
    end

    #Separamos al resto en dos grupos
    accepted = accepted.where.not(speciality: 5).where(isForeign: false)
    for i in(1..accepted.length)
      if i % 2 == 0
        @acceptedM = @acceptedM + accepted.limit(1).offset(i)
      else
        @acceptedV = @acceptedV + accepted.limit(1).offset(i)
      end
    end
  end #splitIntoTurns
end
