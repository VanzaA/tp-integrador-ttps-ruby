module AppointmentsHelper
  def professional_id_to_fullname(professional_id)
    Professional.find(professional_id).full_name
  end
end
