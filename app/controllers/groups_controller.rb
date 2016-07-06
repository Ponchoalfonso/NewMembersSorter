class GroupsController < ApplicationController

  # # # # # # # # # # #
  # Variables globales #
  # # # # # # # # # # #

  $limitPerGroup = 45 #Límite de alumnos por grupo

  #Clave que identifica la especialidad
  $specCode = [0, 1, 2, 3, 4, 5]

  #Definición de la clase identificada
  $specs = ["null", "Programación", "Administración de recursos humanos", "Electrónica", "Contabilidad", "Mantenimiento automotriz"]

  #Número de grupos por especialidad en cada turno
  $groupsPerTurn = [0, 2, 2, 1, 1, 1]

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Actions, a partir de aqui solo las acciones del controlador #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def index
    @admisions = Group.all
=begin
    @Request = Request.order.(:name)
    respond_to do |format|
     format.html
     format.csv { render text: @Request.to_csv }
      format.xls { send_data @Request.to_csv(col_sep: "\t") }
   end
=end
  end

  def generate
    if user_signed_in?
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
          :finalSpeciality  => generateSpeciality(@groups, $currentTurn, r),
          :group => generateGroups(@groups, $currentTurn, $currentSpeciality)
        }))

      end#each
      logger.info selectWhere(@groups, "turn", "vespertino").length

    #  @groups.each do |group|
    #    group.save()
    #  end
  end#if_session

  end#generate

    # # # # # # # # # # # # # # # # # # # # # # # #
   # Methods, apartir de aqui solo metodos privados #
    # # # # # # # # # # # # # # # # # # # # # # # #

  #Variables de apoyo en el método generateSpeciality() y generateSpeciality()
  $currentTurn = ""
  $currentSpeciality = ""

  # Métodos de apoyo #
  private
  def findIndex(speciality)

    index = 0
    #["344100002-13", "333502001-13", "351300001-13", "333400001-13" , "351500002-13"]
    if speciality == 1 or speciality == "344100002-13" or speciality == $specs[1]
      index = 1
    elsif speciality == 2 or speciality == "333502001-13" or speciality == $specs[2]
      index = 2
    elsif speciality == 3 or speciality == "351300001-13" or speciality == $specs[3]
      index = 3
    elsif speciality == 4 or speciality == "333400001-13" or speciality == $specs[4]
      index = 4
    elsif speciality == 5 or speciality == "351500002-13" or speciality == $specs[5]
      index = 5
    end

    return index

  end#findIndex

  private
  def selectWhere(model, row, compare)
    slected = Array.new
    if row == "turn"
      model.each do |m|
        if m.turn == compare
          slected.push(m)
        end
      end#each
    end#rowIfCondition
    if row == "finalSpeciality"
      model.each do |m|
        if m.finalSpeciality == compare
          slected.push(m)
        end
      end#each
    end#rowIfCondition

    return slected

  end#selectWhere

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
  def generateSpeciality(groups, turn, request)

    finalSpeciality ="null"

    #Seleccionamos el turno de la especialidad
    #groups = groups.where(turn: $currentTurn) TODO Borrar esta linea
    groups = selectWhere(groups, "turn", turn)

    # Definimos la especialidad #

    #Guardamos los datos del turno entero
    groupsBackUp = groups

    #Seleccinamos a todos los grupos de la especialidad primaria
    i = findIndex(request.speciality)

    #groups = groups.where(finalSpeciality: $specs[i]) TODO Borrar esta linea
    groups = selectWhere(groups, "finalSpeciality", $specs[i])

    #Revisamos si la especialidad primaria esta completa
    if groups.length <= $limitPerGroup * $groupsPerTurn[i]
      finalSpeciality = $specs[i]
    end
    #Recuperamos los datos del turno entero
    groups = groupsBackUp

    #Seleccinamos a todos los grupos de la especialidad secundaria
    i = findIndex(request.secondSpeciality)
    #groups = groups.where(finalSpeciality: $specs[i]) TODO Borrar esta linea
    groups = selectWhere(groups, "finalSpeciality", $specs[i])
    #Revisamos si la especialidad secundaria esta completa
    if groups.length <= $groupsPerTurn[i] * $limitPerGroup and finalSpeciality == "null"
      finalSpeciality = $specs[i]
    end
    #Si ambas especialidades están completas lo guardamos como Exception para posteriormente agregarlo en el grupo con menos alumnos
    if finalSpeciality == "null"
      finalSpeciality = "Exception"
      i = 0;
    end#if

    #Valores de retorno
    $currentSpeciality = finalSpeciality
    return finalSpeciality

  end#setGroup

  private
  def generateGroups(groups, turn, finalSpeciality)

    group = "null"

    #Descartamos a los alumnos que no logran entrar ni en su primer ni sugunda especialidad
    if finalSpeciality == "Exception"
      group = "E"
    end

    #Generamos un indice
    i = findIndex($currentSpeciality)

    #Seleccinamos los alumnos del turno dado
    groups = selectWhere(groups, "turn", turn)
    #Seleccionamos los alumnos de la especialidad definida
    groups = selectWhere(groups, "finalSpeciality", $specs[i])
    logger.info "#{groups.length} del turno #{turn}" #TODO copy this line

    # Comparaciones #
    if groups.length <= $limitPerGroup and groups.length > 0
      group = "A"
    elsif groups.length > $limitPerGroup and groups.length
      group = "B"
    else
      group = "EE" #Si alguien ve EE como grupo en algun error, hay un problema en pasadas lineas de código
    end

    return group

  end#generateGroups

end#controller
