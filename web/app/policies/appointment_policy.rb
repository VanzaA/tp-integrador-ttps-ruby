class AppointmentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.consultante? || user.asistente?
  end

  def show?
    user.admin? || user.consultante? || user.asistente?
  end

  def new?
    user.admin? || user.asistente?
  end

  def edit?
    user.admin? || user.asistente?
  end

  def create?
    user.admin? || user.asistente?
  end

  def update?
    user.admin? || user.asistente?
  end

  def destroy?
    user.admin? || user.asistente?
  end

  def reschedule?
    user.admin? || user.asistente?
  end

  def update_time?
    user.admin? || user.asistente?
  end
end