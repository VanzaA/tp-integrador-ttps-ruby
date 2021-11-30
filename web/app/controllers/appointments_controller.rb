class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :reschedule, :update_time]

  # GET /appointments
  def index
    authorize!

    @appointments = Appointment.all
  end

  # GET /appointments/1
  def show
    authorize!
  end

  def reschedule
    authorize!
  end

  def update_time
    authorize!
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'El turno se actualizo correctamente.'
    else
      render :reschedule
    end
  end
  # GET /appointments/new
  def new
    authorize!

    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
    authorize!
  end

  # POST /appointments
  def create
    authorize!
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to @appointment, notice: 'El turno se creo correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /appointments/1
  def update
    authorize!
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'El turno se actualizo correctamente.'
    else
      render :edit
    end
  end

  # DELETE /appointments/1
  def destroy
    authorize!

    @appointment.destroy
    redirect_to appointments_url, notice: 'El turno se cancelo correctamente.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :time, :professional_id, :name, :surname, :phone, :notes)
    end
end
