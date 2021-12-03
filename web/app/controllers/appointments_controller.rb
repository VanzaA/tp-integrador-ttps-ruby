class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :reschedule, :update_time]
  NO_PROFESSIONAL_SELECTED = "Todos"

  def index
    authorize!

    @appointments = Appointment.all.order(:date)
  end

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
  def new
    authorize!

    @appointment = Appointment.new
  end

  def edit
    authorize!
  end

  def create
    authorize!
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      redirect_to @appointment, notice: 'El turno se creo correctamente.'
    else
      render :new
    end
  end

  def update
    authorize!
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'El turno se actualizo correctamente.'
    else
      render :edit
    end
  end

  def destroy
    authorize!

    @appointment.destroy
    redirect_to appointments_url, notice: 'El turno se cancelo correctamente.'
  end

  def export
    authorize!
  end

  def generate_file
    authorize!

    @appointments = []
    if export_params[:all_week] == "1"
      date = Date.parse(export_params[:date])
      @begining_of_week = date - date.wday.days
      @appointments = Appointment.date_between(@begining_of_week, @begining_of_week + 6.days)
    else
      @appointments = { export_params[:date] => Appointment.where(date: export_params[:date]) }
    end

    filter_appointments_by_professional

    template = File.read(lookup_context.find_template("appointments/template_calendar").identifier)
    content = ERB.new(template).result_with_hash({
      days: get_days_for_calendar,
      appointments: @appointments,
      range_time: range_time
    })

    send_data content, filename: "calendar.html"
  end

  private

  def filter_appointments_by_professional
    if export_params[:professional_id] != NO_PROFESSIONAL_SELECTED
      @appointments = @appointments.flat_map {|k,v|  {k => v.select{ |appointment| appointment.professional_id == export_params[:professional_id].to_i}}}.reduce(:merge)
    end
  end

  def get_days_for_calendar
    if export_params[:all_week] == "1"
      (0...7).to_a.map { |num| (@begining_of_week + num.days)}
    else
      days = [export_params[:date]]
    end
  end

  def range_time
    (8..20).flat_map do |hour|
      (0..3).map do |min|
        "#{hour}:#{min*15 == 0 ? '00' : min*15}"
      end
    end
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:date, :time, :professional_id, :name, :surname, :phone, :notes)
  end

  def export_params
    params.fetch(:export, {}).permit(:professional_id, :date, :all_week)
  end

end
