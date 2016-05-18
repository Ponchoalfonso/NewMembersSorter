class GroupsController < ApplicationController

  #Actions, a partir de aqui solo las acciones del controlador

  def index
  end

  def generate

    @recommended = Request.where(isRecommended: true)
    @accepted = Request.where(isRecommended: false).order("examMark DESC", "schoolAverage DESC").limit(300)

    #Creamos dos variables que contendran a los alumnos separados por turnos
    @acceptedM
    @acceptedV

    #Variable para los alumnos que no alcancen lugar en la especialidad primaria
    @acceptedMS = Array.new
    @acceptedVS = Array.new

    #Variables para cada grupo del turno Matutino
    @PrograMA = Array.new
    @PrograMB = Array.new
    @AdminMA = Array.new
    @AdminMB = Array.new
    @ContaMA = Array.new
    @ElectroMA = Array.new

    #Variables para cada grupo del turno Vespertino
    @PrograVA = Array.new
    @PrograVB = Array.new
    @AdminVA = Array.new
    @ContaVA = Array.new
    @ElectroVA = Array.new
    @MecaVA = Array.new

    #Dividimos a los alumnos aceptados en turnos distintos
    splitIntoTurns(@accepted)


    #Enviamos a los alumnos a sus respectivos grupos
    sendToSpeciality("matutino")
    sendToSpeciality("vespertino")

  end #generate

  # # # # # # # # # # # # # # # # # # # # # # # # #
  # Methods, apartir de aqui solo metodos privados #
  # # # # # # # # # # # # # # # # # # # # # # # # #

  private
  def splitIntoTurns(accepted)
    #Mando a los usuarios de mecanica directamente al turno vespertino\
    @acceptedV = accepted.where(speciality: 5)

    #Manda a los usurarios recomendados
    @acceptedM = @recommended

    #Manda a los alumnos foraneos directamente al turno matutino
    @acceptedM += accepted.where(isForeign: true).where.not(speciality: 5)

    #Separamos al resto en dos grupos
    accepted = accepted.where.not(speciality: 5).where(isForeign: false)
    for i in(1..accepted.length)
      if i % 2 == 0
        @acceptedM += accepted.limit(1).offset(i)
      else
        @acceptedV += accepted.limit(1).offset(i)
      end#if
    end#for
  end #splitIntoTurns

  private
  def sendToSpeciality(turno)

 # => Turno Matutino <= #

    if turno == "matutino"
      @acceptedM.each do |m|
        case m.speciality
        when 1
          if @PrograMA.length < 25
            @PrograMA.push(m)
          elsif @PrograMB.length < 25
            @PrograMB.push(m)
          else
            @acceptedMS.push(m)
          end
        #Termina When 1
        when 2
          if @AdminMA.length < 25
            @AdminMA.push(m)
          elsif @AdminMB.length < 25
            @AdminMB.push(m)
          else
            @acceptedMS.push(m)
          end
        #Termina When 2
        when 3
          if @ElectroMA.length < 25
            @ElectroMA.push(m)
          else
            @acceptedMS.push(m)
          end
        #Termina When 3
        when 4
          if @ContaMA.length < 25
            @ContaMA.push(m)
          else
            @acceptedMS.push(m)
          end
        #Termina When 4

        end#case
      end#each
    end#if matutino

 # => Turno Vespertino <= #

    if turno == "vespertino"
      @acceptedV.each do |m|
        case m.speciality
        when 1
          if @PrograVA.length < 25
            @PrograVA.push(m)
          elsif @PrograVB.length < 25
            @PrograVB.push(m)
          else
            @acceptedVS.push(m)
          end
        #Termina When 1
        when 2
          if @AdminVA.length < 25
            @AdminVA.push(m)
          else
            @acceptedVS.push(m)
          end
        #Termina When 2
        when 3
          if @ElectroVA.length < 25
            @ElectroVA.push(m)
          else
            @acceptedVS.push(m)
          end
        #Termina When 3
        when 4
          if @ContaVA.length < 25
            @ContaVA.push(m)
          else
            @acceptedVS.push(m)
          end
        #Termina When 4
        when 5
          if @MecaVA.length < 25
            @MecaVA.push(m)
          else
            @acceptedVS.push(m)
          end
        #Termina When 4

        end#case
      end#each
    end#if matutino

  end#sendToSpeciality

  private
  def sendToSecondSpeciality(turno)

 # => Turno Matutino <= #

    if turno == "matutino"
      @acceptedMS.each do |m|
        case m.secondSpeciality
        when 1
          if @PrograMA.length < 25
            @PrograMA.push(m)
          elsif @PrograMB.length < 25
            @PrograMB.push(m)
          else
            @error.push(m)
          end
        #Termina When 1
        when 2
          if @AdminMA.length < 25
            @AdminMA.push(m)
          elsif @AdminMB.length < 25
            @AdminMB.push(m)
          else
            @error.push(m)
          end
        #Termina When 2
        when 3
          if @ElectroMA.length < 25
            @ElectroMA.push(m)
          else
            @error.push(m)
          end
        #Termina When 3
        when 4
          if @ContaMA.length < 25
            @ContaMA.push(m)
          else
            @error.push(m)
          end
        #Termina When 4

        end#case
      end#each
    end#if matutino

 # => Turno Vespertino <= #

    if turno == "vespertino"
      @acceptedVS.each do |m|
        case m.speciality
        when 1
          if @PrograVA.length < 25
            @PrograVA.push(m)
          elsif @PrograVB.length < 25
            @PrograVB.push(m)
          else
            @errorV.push(m)
          end
        #Termina When 1
        when 2
          if @AdminVA.length < 25
            @AdminVA.push(m)
          else
            @errorV.push(m)
          end
        #Termina When 2
        when 3
          if @ElectroVA.length < 25
            @ElectroVA.push(m)
          else
            @errorV.push(m)
          end
        #Termina When 3
        when 4
          if @ContaVA.length < 25
            @ContaVA.push(m)
          else
            @errorV.push(m)
          end
        #Termina When 4
        when 5
          if @MecaVA.length < 25
            @MecaVA.push(m)
          else
            @errorV.push(m)
          end
        #Termina When 4

        end#case
      end#each
    end#if matutino

  end#sendToSpeciality

end
