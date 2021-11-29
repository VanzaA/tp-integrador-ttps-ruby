class ProfessionalPolicy < ApplicationPolicy
  def index?
    user.admin? || user.consultante? || user.asistente?
  end

  def new?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def cancel_all_appointments?
    user.admin?
  end
end