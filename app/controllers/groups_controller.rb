class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # # # # # # # # # # #
  # Variables globales #
  # # # # # # # # # # #

  $limitPerGroup = 50 #Límite de alumnos por grupo

  #Clave que identifica la especialidad
  $specCode = [0, 1, 2, 3, 4, 5]

  #Definición de la clase identificada
  $specs = ["null", "Programación", "Administración de recursos humanos", "Electrónica", "Contabilidad", "Mantenimiento automotríz"]

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
      format.html { redirect_to groups_path, notice: 'Group fué eliminado con éxito.' }
      format.json { head :no_content }
    end
  end

  def generate
    #Datos generales


          #Turno matutino
          @admiM
          @prograM
          @conta
          @electroM = Request.limit(0)
          #Turno vespertino
          @admiV
          @prograV
          @electroV = Request.limit(0)
          @meca

          #Salones programacion
          @prograMA
          @prograMB
          @prograVA
          @prograVB

          #salones admi
          @admiMA
          @admiMB
          @admiVA
          @admiVB

          @accepted = Request.all.order("examMark DESC", "schoolAverage DESC").limit(600)

          if Accepted.all.length < 1
            @todosAccepted = Accepted.limit(0)
            #Modelo Accepted
            @accepted.each do |r|
              @todosAccepted.push(Accepted.new({
                :name => r.name,
                :examMark => r.examMark,
                :schoolAverage => r.schoolAverage,
                :isRecommended => r.isRecommended,
                :isForeign => r.isForeign,
                :speciality => r.speciality,
                :secondSpeciality => r.secondSpeciality
                }))
              end
              @todosAccepted.each do |g|
                g.save()
              end
        end
         #Modelo Resto
         if Resto.all.length < 1
           @restos2 = Resto.limit(0)
           @accepted.each do |r|
             @restos2.push(Resto.new({
               :name => r.name,
               :examMark => r.examMark,
               :schoolAverage => r.schoolAverage,
               :isRecommended => r.isRecommended,
               :isForeign => r.isForeign,
               :speciality => r.speciality,
               :secondSpeciality => r.secondSpeciality
               }))
             end

             @restos2.each do |g|
               g.save()
             end
         end

          @allAccepted = Accepted.all
          @restos = Resto.all


          #primera especialidad
          @progra = @allAccepted.where(speciality:1).limit(200)
          @p = 200 - @progra.length
          delite @progra
          @admi = @allAccepted.where(speciality: 2).limit(200)
          @a = 200 - @admi.length
          delite @admi
          @electro = @allAccepted.where(speciality: 3).limit(100)
          @e = 100 - @electro.length
          delite @electro
          @conta = @allAccepted.where(speciality: 4).limit(50)
          @c = 50 - @conta.length
          delite @conta
          @meca = @allAccepted.where(speciality: 5).limit(50)
          @m = 50 - @meca.length
          delite @meca

          #Segunda especialidad
          @progra2 = @restos.where(secondSpeciality: 1).limit(@p)
          delete2 @progra2
          @admi2 = @restos.where(secondSpeciality: 2).limit(@a)
          delete2 @admi2
          @electro2 = @restos.where(secondSpeciality: 3).limit(@e)
          delete2 @electro2
          @conta2 = @restos.where(secondSpeciality: 4).limit(@c)
          delete2 @conta2
          @meca2 = @restos.where(secondSpeciality: 5).limit(@m)
          delete2 @meca2
          #rellena las especialidades con la segunda opcion

          @progra2.each do |x|
            @progra.push(x)
          end
          @admi2.each do |x|
            @admi.push(x)
          end
          @electro2.each do |x|
            @electro.push(x)
          end
          @conta2.each do |x|
            @conta.push(x)
          end
          @meca2.each do |x|
            @meca.push(x)
          end

          #Acomodo por turno y grupos

          #Programacion
          turno @progra

          @prograM = @turnoM
          @prograV = @turnoV

          especialidad @prograM,@prograV

          @prograMA  = @especialidadMA
          @prograMB  = @especialidadMB
          @prograVA  = @especialidadVA
          @prograVB  = @especialidadVB

          #Administracion
          turno @admi

          @admiM = @turnoM
          @admiV = @turnoV

          especialidad @admiM,@admiV

          @admiMA  = @especialidadMA
          @admiMB  = @especialidadMB
          @admiVA  = @especialidadVA
          @admiVB  = @especialidadVB

          #Electronica
          @electro.each do |x|
            if x.isForeign == true
                @electroM.push(x)
            end
          end

          @i = 0
          @electro.each do |x|
            @i = @i + 1
            if @i%2 == 0 and @electroM.length < 50 and x.isForeign == false
              @electroM.push(x)
            elsif x.isForeign == false
              @electroV.push(x)
            end
          end


        @groups = Group.limit(0)

        @conta.each do |r|
          @groups.push(Group.new({
            :name => r.name,
            :examMark => r.examMark,
            :schoolAverage => r.schoolAverage,
            :isRecommended => r.isRecommended,
            :isForeign => r.isForeign,
            :speciality => r.speciality,
            :secondSpeciality => r.secondSpeciality,
            :turn => "matutino",
            :finalSpeciality  => "Contabilidad",
            :group => "A"
          }))
        end
        @electroM.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "matutino",
              :finalSpeciality  => "Electrónica",
              :group => "A"
            }))
        end


        @electroV.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Electrónica",
              :group => "A"
            }))
        end
        @meca.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Mantenimiento automotríz",
              :group => "A"
            }))
        end

        #Salones programacion
        @prograMA.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "matutino",
              :finalSpeciality  => "Programación",
              :group => "A"
            }))
        end
        @prograMB.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "matutino",
              :finalSpeciality  => "Programación",
              :group => "B"
            }))
        end
        @prograVA.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Programación",
              :group => "A"
            }))
        end
        @prograVB.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Programación",
              :group => "B"
            }))
        end

        #salones admi
        @admiMA.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "matutino",
              :finalSpeciality  => "Administración de recursos humanos",
              :group => "A"
            }))
        end
        @admiMB.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "matutino",
              :finalSpeciality  => "Administración de recursos humanos",
              :group => "B"
            }))
        end
        @admiVA.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Administración de recursos humanos",
              :group => "A"
            }))
        end
        @admiVB.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "vespertino",
              :finalSpeciality  => "Administración de recursos humanos",
              :group => "B"
            }))
        end

        @restos.each do |r|
          @groups.push(Group.new({
              :name => r.name,
              :examMark => r.examMark,
              :schoolAverage => r.schoolAverage,
              :isRecommended => r.isRecommended,
              :isForeign => r.isForeign,
              :speciality => r.speciality,
              :secondSpeciality => r.secondSpeciality,
              :turn => "null",
              :finalSpeciality  => "Exception",
              :group => "null"
            }))
        end



        if Group.all.length < 1
          @groups.each do |g|
            g.save()
          end
        end

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

  #Metodos que ayudan acomodar a los alumnos
    private
    def turno general
      @turnoM  = Request.limit(0)
      @turnoV  = Request.limit(0)
      @turno = general
      @turno.each do |x|
        if x.isForeign == true
            @turnoM.push(x)
        end
      end

      @i = 0
      @turno.each do |x|
        @i = @i + 1
        if @i%2 == 0 and @turnoM.length < 100 and x.isForeign == false
          @turnoM.push(x)
        elsif x.isForeign == false
          @turnoV.push(x)
        end
      end
      return @turnoM,@turnoV
    end

    private
    def especialidad turnoM,turnoV

      @especialidadMA  = Request.limit(0)
      @especialidadMB  = Request.limit(0)
      @especialidadVA  = Request.limit(0)
      @especialidadVB  = Request.limit(0)

      @especialidadM = turnoM
      @i = 0
      @especialidadM.each do |x|
        @i = @i + 1
        if @i%2 == 0
          @especialidadMA.push(x)
        else
          @especialidadMB.push(x)
        end
      end

      @especialidadV = turnoV
      @i = 0
      @especialidadV.each do |x|
        @i = @i + 1
        if @i%2 == 0
          @especialidadVA.push(x)
        else
          @especialidadVB.push(x)
        end
      end
      return @especialidadMA,@especialidadMB,@especialidadVA,@especialidadVB
    end

    private
    def delite general
      @delite = general
      @delite.each do |x|
      @restos.each do |j|
          if j.name == x.name
            j.delete
          end
        end
      end
      return @restos
    end

    private
    def delete2 general
      @delite = general
      @delite.each do |x|
      @restos.each do |j|
          if j.name == x.name
            j.name = ""
            j.examMark = 0
            j.schoolAverage = 0
            j.isRecommended = false
            j.isForeign = false
            j.speciality = 0
            j.secondSpeciality = 0
          end
        end
      end
      return @restos
    end


end#controller
