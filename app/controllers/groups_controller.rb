class GroupsController < ApplicationController

  #Variables globales
  $limitPerGroup = 45;
  $specCode = [1, 2 , 3, 4 , 5]

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate

    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(540)


    #Separamos por especialidades
    @progra = @accepted.where(speciality: 1, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(180) #4 Grupos
    @admin = @accepted.where(speciality: 2, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(180) # 4 Grupos
    @electro = @accepted.where(speciality: 3, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(90) # 2 Grupos
    @conta = @accepted.where(speciality: 4, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(45) # 1 Grupos
    @meca = @accepted.where(speciality: 5, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(45) # 1 Grupo

    offset = 0

    @groups = Array.new

    @progra.each do |r|

      offset++

      @groups.push(Group.new({
        :name => r.name,
        :examMark => r.examMark,
        :schoolAverage => r.schoolAverage,
        :isRecommended => r.isRecommended,
        :isForeign => r.isForeign,
        :speciality => r.speciality,
        :secondSpeciality => r.secondSpeciality,
        :turn => generateTurn(r.isForeign, offset, r),
        :finalSpeciality  => generateSpeciality(generateTurn(r.isForeign, offset, r), @groups, r, 0),
        :group => generateSpeciality(generateTurn(r.isForeign, offset, r), @groups, r, 1)
      }))
    end#each

  #  @groups.each do |group|
  #    group.save()
  #  end

  end#generate

    # # # # # # # # # # # # # # # # # # # # # # # #
   # Methods, apartir de aqui solo metodos privados #
    # # # # # # # # # # # # # # # # # # # # # # # #
  private
  def generateTurn(foreign, offset, group)

    turn = "null"

    if offset%2 == 1 || group.speciality == 5
      turn = "vespertino"
    elsif foreign
      turn = "matutino"
    elsif offset%2 == 0
      turn = "matutino"
    end

    return turn

  end#getTurn

  private
  def generateSpeciality(turn, groups, speciality, ret)

    group = "null"
    finalSpeciality ="null"

    #Seleccionamos el turno de la especialidad
    if turn == "matutino"
      if groups.instance_of? Array
        groups.keep_if do |g|
          g.turn = "matutino"
        end#each
      end
    else
      if groups.instance_of? Array
        groups.keep_if do |g|
          g.turn = "vespertino"
        end#each
      end
    end#if

    #Seleccionamos la especialidad
    if groups.instance_of? Array
      groups.keep_if do |g|
        g.speciality = group
      end
    end

    #Separamos en grupos
    group = generateGroups(groups, speciality, turn)

    #Valores de retorno
    if ret == 0
      return finalSpeciality
    elsif ret == 1
      return group
    end

  end#setGroup

  private
  def generateGroups(groups, speciality, turn)

    group = "null";

    #Posibles grupos del turno matutino
    if turn == "matutino"

      case speciality

      when $specCode[0] #Programación
        if groups.length <= $limitPerGroup
          group = "A"
        else
          group = "B"
        end#if
      when $specCode[1] #Administración
        if groups.length <= $limitPerGroup
          group = "A"
        else
          group = "B"
        end#if
      when $specCode[2] #Electrónica
        group = "A"
      when $specCode[3] #Contabilidad
        group = "A"
      end#case

    #Posibles grupos del turno vespertino
    elsif turn == "vespertino"

      case speciality

      when $specCode[0] #Programación
        if groups.length <= $limitPerGroup
          group = "A"
        else
          group = "B"
        end#if
      when $specCode[1] #Administración
        if groups.length <= $limitPerGroup
          group = "A"
        else
          group = "B"
        end#if
      when $specCode[2] #Electrónica
        group = "A"
      when $specCode[4] #Contabilidad
        group = "A"
      end#case

    end#if

    return group

  end#generateGroups

end
