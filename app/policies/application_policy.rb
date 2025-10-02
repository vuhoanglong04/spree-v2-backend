# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :current_account_user, :record

  def initialize(current_account_user, record)
    @current_account_user = current_account_user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(current_account_user, scope)
      @current_account_user = current_account_user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :current_account_user, :scope
  end
end
