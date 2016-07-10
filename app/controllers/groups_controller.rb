class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # # # # # # # # # # #
  # Variables globales #
  # # # # # # # # # # #

  $limitPerGroup = 50 #Límite de alumnos por grupo

  #Clave que identifica la especialidad
  $specCode = [0, 1, 2, 3, 4, 5]

  #Definición de la clase identificada
  $specs = ["null", "Programación", "Administración de recursos humanos", "Electrónica", "Contabilidad", "Mantenimiento automotriz"]

  #Número de grupos por especialidad en cada turno
  $groupsPerTurn = [0, 2, 2, 1, 1, 1]

  #Turnos posibles
  $turns = ["matutino", "vespertino"]

  #Grupos posibles
  $g = ["A", "B"]

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Actions, a partir de aqui solo las acciones del controlador #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def index
    @groups = Group.all
    respond_to do |format|
     format.html
     format.csv { render text: @groups.to_csv }
      format.xls { send_data @groups.to_csv(col_sep: "\t") }
   end

  end

  def search
    if params[:search]
      @groups = Group.where('name LIKE ?', "%#{params[:search]}%")
    else
      @groups = Group.all
    end
  end

  def deleteData
    if user_signed_in? and Group.all.length > 0

      Group.destroy_all
      #Request.destroy_all
      #Request.reset_pk_sequences!

    end#if user_signed_in
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group fué creado con éxito.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group fué actualizado con éxito.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Group fué eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  def generate
    if user_signed_in?
      #Separamos a los aceptados de los demás
      @accepted = Request.all.order("examMark DESC", "schoolAverage DESC").limit(600)
      logger.info @accepted.length

      #Definimos offset
      offset = 0

      #Definimos @groups como un Array y así poder utilizar el método push()
      @groups = Group.limit(0)

      #Iteramos a todos nuestros alumnos aceptados guardando a cada uno en la variable 'r'
      @accepted.each do |r|

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
          :finalSpeciality  => generateSpeciality(@groups, r),
          :group => generateGroups(@groups, $currentSpeciality),
          :turn => generateTurn(offset, $currentSpeciality, r.isForeign)
        }))

      end#each
      prueba = selectWhere(@groups, "turn", "vespertino")
      prueba = selectWhere(prueba, "finalSpeciality", $specs[2])
      prueba = selectWhere(prueba, "group", $g[0])

      @groups.each do |group|
        group.save()
      end
    else
      redirect_to groups_path()
    end#if_session

  end#generate

    # # # # # # # # # # # # # # # # # # # # # # # #
   # Methods, apartir de aqui solo metodos privados #
    # # # # # # # # # # # # # # # # # # # # # # # #

                                                    ###Métodos para el CRUD de Groups###
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end
      # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :examMark, :schoolAverage, :isRecommended, :isForeign, :speciality, :secondSpeciality, :turn, :finalSpeciality, :group)
    end

  #Variables de apoyo en el método generateTurn()
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
    if row == "group"
      model.each do |m|
        if m.group == compare
          slected.push(m)
        end
      end#each
    end#rowIfCondition

    return slected

  end#selectWhere

  private
  def generateSpeciality(groups, request)

    finalSpeciality ="null"

    #Definimos el index de la especialidad
    f = findIndex(request.speciality)
    s = findIndex(request.secondSpeciality)

    #Seleccionamos a los alumnos que hay actualmente en la primer y segunda especialidad
    firstSelection = selectWhere(groups, "finalSpeciality", $specs[f])
    secondSelection = selectWhere(groups, "finalSpeciality", $specs[s])

    if firstSelection.length < $turns.length * $groupsPerTurn[f] * $limitPerGroup * $g.length
      finalSpeciality = $specs[f]
    elsif secondSelection.length < $turns.length * $groupsPerTurn[s] * $limitPerGroup * $g.length
      finalSpeciality = $specs[s]
    else
      finalSpeciality = "Exception"
    end

    $currentSpeciality = finalSpeciality
    return finalSpeciality

  end#setGroup

  private
  def generateGroups(groups, finalSpeciality)

    group = "null"

    #Descartamos a los alumnos que no logran entrar ni en su primer ni sugunda especialidad
    if finalSpeciality == "Exception"
      group = "E"
    end

    #Generamos un indice
    i = findIndex(finalSpeciality)

    #Seleccionamos los alumnos de la especialidad definida
    slection = selectWhere(groups, "finalSpeciality", $specs[i])

    # Comparaciones #
    if groups.length < $limitPerGroup * $groupsPerTurn[i] * $g.length
      group = "A"
    elsif groups.length >= $limitPerGroup * $groupsPerTurn[i] * $g.length and groups.length < $limitPerGroup * $groupsPerTurn[i] * $turns.length * $g.length
      group = "B"
    else
      group = "EE" #Si alguien ve EE como grupo en algun error, hay un problema en pasadas lineas de código
    end

    return group

  end#generateGroups

  private
  def generateTurn(offset, finalSpeciality, foreign)

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

    i = findIndex(finalSpeciality)

    #Si le tocó turno vespertino por azar, automáticamente se va al turno matutino por ser de la especialidad de contabilidad
    if i == 4
      turn = "matutino"
    elsif i == 5
      turn = "vespertino"
    end#if

    return turn

  end#generateTurn

end#controller
