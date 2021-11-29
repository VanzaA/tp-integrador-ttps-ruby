class ProfessionalsController < ApplicationController
  before_action :set_professional, only: [:show, :edit, :update, :destroy, :cancel_all_appointments]

  # GET /professionals
  def index
    authorize!

    @professionals = Professional.all
  end

  # GET /professionals/new
  def new
    authorize!

    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
    authorize!
  end

  # POST /professionals
  def create
    authorize!
    @professional = Professional.new(professional_params)

    if @professional.save
      redirect_to professionals_path, notice: "El profesional #{@professional.full_name} se creo correctamente."
    else
      render :new
    end
  end

  # PATCH/PUT /professionals/1
  def update
    authorize!
    if @professional.update(professional_params)
      redirect_to professionals_path, notice: "El profesional #{@professional.full_name} se actualizo correctamente."
    else
      render :edit
    end
  end

  def cancel_all_appointments
    authorize!
    @professional.update(professional_params)
    redirect_to professionals_path, notice: "Se cancelaron todos los turnos del profesional #{@professional.full_name}."
  end

  def download
    content = "<div>this is a test</div>"
    send_data content, filename: "test.html"
  end

  # DELETE /professionals/1
  def destroy
    authorize!

    @professional.destroy
    redirect_to professionals_url, notice: "El profesional #{@professional.full_name} se borro correctamente."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_professional
    @professional = Professional.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def professional_params
    params.require(:professional).permit(:name, :surname)
  end
end
