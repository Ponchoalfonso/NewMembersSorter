class GroupsController < ApplicationController

  # # # # # # # # # # #
  # Variables globales #
  # # # # # # # # # # #

  $limitPerGroup = 45 #Límite de alumnos por grupo
  $limitOfGroups = [4, 4, 2, 1, 1] #Límite de grupos de ambos turnos

  #Clave que identifica la especialidad
  #$specCode = ["344100002-13", "333502001-13", "351300001-13", "333400001-13" , "351500002-13"]
  $specCode = [1, 2, 3, 4, 5]

  #Definición de la clase identificada
  $specs = ["", "Programación", "Administración de recursos humanos", "Electrónica", "Contabilidad", "Mecánica automotriz"]

  #$sepcs = Hash.new({
  #  1 => "Programación",
  #  2 => "Administración de recursos humanos",
  #  3 => "Electrónica",
  #  4 => "Contabilidad",
  #  5 => "Mecánica automotriz"
  #})

  #Número de grupos por especialidad en cada turno
  $groupsPerTurn = [0, 2 ,2 ,1 ,1 ,1]

  #$groupsPerTurn = Hash.new({
  #  1 => 2,
  #  2 => 2,
  #  3 => 1,
  #  4 => 1,
  #  5 => 1
  #})

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Actions, a partir de aqui solo las acciones del controlador #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def index
    @baseGroup = Group.new
  end

  def basePost
    @baseGroup = Group.create({
      :name => "ini",
      :examMark => 0,
      :schoolAverage => 0,
      :isRecommended => false,
      :isForeign => false,
      :speciality => 0,
      :secondSpeciality => 0,
      :turn => "noTurn",
      :finalSpeciality  => "noSpeciality",
      :group => "noGroup"
    })
    if @baseGroup.save
      redirect_to "/groups/generate"
    end
  end


  def generate

    #Separamos a los aceptados de los demás
    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(540)


    #Separamos por especialidades
    @progra = @accepted.where(speciality: 1, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(180) #4 Grupos
    @admin = @accepted.where(speciality: 2, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(180) # 4 Grupos
    @electro = @accepted.where(speciality: 3, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(90) # 2 Grupos
    @conta = @accepted.where(speciality: 4, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(45) # 1 Grupos
    @meca = @accepted.where(speciality: 5, isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(45) # 1 Grupo

    #Definimos offset
    offset = 0

    #Definimos @groups como un Array y así poder utilizar el método push()
    @groups = Group.limit(0)

    #Iteramos a todos nuestros alumnos aceptados guardando a cada uno en la variable 'r'
    @progra.each do |r|

      #Offset es el conteo de "Requests" dentro del ciclo
      offset = offset + 1

      #Guardamos cada "Request" en un array definiendo su turno, especialidad, y grupo para posteriormente guardarlos a todos en la base de datos
      @groups.push(Group.new({
        :name => r.name,
        :examMark => r.examMark,
        :schoolAverage => r.schoolAverage,
        :isRecommended => r.isRecommended,
        :isForeign => r.isForeign,
        :speciality => r.speciality,
        :secondSpeciality => r.secondSpeciality,
        :turn => generateTurn(r.isForeign, offset, r),
        :finalSpeciality  => generateSpeciality($currentTurn, @groups, r, 0),
        :group => generateSpeciality($currentTurn, @groups, r, 1)
      }))

    end#each

  #  @groups.each do |group|
  #    group.save()
  #  end

  end#generate

    # # # # # # # # # # # # # # # # # # # # # # # #
   # Methods, apartir de aqui solo metodos privados #
    # # # # # # # # # # # # # # # # # # # # # # # #

  #Variable de apoyo en el método generateSpeciality()
  $currentTurn = ""

  private
  def generateTurn(foreign, offset, request)

    turn = ""

    #Dividimos en turnos de 1 en 1 para equilibrar los alumnos de buen promedio
    if offset%2 == 0
      turn = "matutino"
    else
      turn = "vespertino"
    end#if

    #Una vez seleccionado el turno revisamos si es foráneo
    if foreign
      turn = "matutino"
    end

    #Si le tocó turno matutino por azar o por ser foráneo, automáticamente se va al turno vespertino por ser de la especialidad de mecánica
    if request.speciality == 5
      turn = "vespertino"
    end

    $currentTurn = turn
    return turn

  end#generateTurn

  private
  def generateSpeciality(turn, groups, request, ret)

    group = ""
    finalSpeciality =""

    #Seleccionamos el turno de la especialidad
    if turn == "matutino"
      groups = groups.where(turn: "matutino")
    elsif turn == "vespertino"
      groups = groups.where(turn: "vespertino")
    end#if

    # Definimos la especialidad #

    #Guardamos los datos del turno entero
    groupsBackUP = groups

    enter = true
    #Seleccinamos a todos los grupos de la especialidad primaria
    s = request.speciality
    groups = groups.where(finalSpeciality: $specs[s])

    #Revisamos si la especialidad primaria esta completa
    if groups.length < $groupsPerTurn[s] * $limitPerGroup
      finalSpeciality = $specs[s]
    else
      enter = false
    end
    #Recuperamos los datos del turno entero
    groups = groupsBackUP

    #Seleccinamos a todos los grupos de la especialidad secundaria
    s = request.secondSpeciality
    groups = groups.where(finalSpeciality: $specs[s])
    #Revisamos si la especialidad secundaria esta completa
    if groups.length < $groupsPerTurn[s] * $limitPerGroup && !enter
      finalSpeciality = $specs[s]
    #Si ambas especialidades están completas lo guardamos como Exception para posteriormente agregarlo en el grupo con menos alumnos
    else
      finalSpeciality = "Exception"
    end#if

    #Separamos en grupos
    group = generateGroups(groups, request.speciality, turn)

    #Valores de retorno
    if ret == 0
      return finalSpeciality
    elsif ret == 1
      return group
    end

  end#setGroup

  private
  def generateGroups(groups, speciality, turn)

    group = "null"

    #Posibles grupos del turno matutino
    if turn == "matutino"

      case speciality

      when $specCode[0] #Programación
        if groups.length < $limitPerGroup
          group = "A"
        elsif groups.length >= $limitPerGroup
          group = "B"
        end#if
      when $specCode[1] #Administración
        if groups.length < $limitPerGroup
          group = "A"
        elsif groups.length >= $limitPerGroup
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
        if groups.length < $limitPerGroup
          group = "A"
        elsif groups.length >= $limitPerGroup
          group = "B"
        end#if
      when $specCode[1] #Administración
        if groups.length < $limitPerGroup
          group = "A"
        elsif groups.length >= $limitPerGroup
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

end#controller
