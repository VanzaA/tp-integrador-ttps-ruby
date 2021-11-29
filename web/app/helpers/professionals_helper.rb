module ProfessionalsHelper
  def can_cancel_all(professional)
    true if professional.appointments.count > 0
  end
end
