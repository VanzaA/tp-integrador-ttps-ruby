class ProfessionalsController < ApplicationController
  before_action :set_professional, only: [:show, :edit, :update, :destroy]

  # GET /professionals
  def index
    @professionals = Professional.all
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals
  def create
    @professional = Professional.new(professional_params)

    if @professional.save
      redirect_to professionals_path, notice: 'El profesional se creo correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /professionals/1
  def update
    if @professional.update(professional_params)
      redirect_to professionals_path, notice: 'El profesional se actualizo correctamente.'
    else
      render :edit
    end
  end

  def download
    content = "<div>this is a test</div>"
    send_data content, filename: "test.html"
  end

  # DELETE /professionals/1
  def destroy
    @professional.destroy
    redirect_to professionals_url, notice: 'El profesional se borro correctamente.'
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
