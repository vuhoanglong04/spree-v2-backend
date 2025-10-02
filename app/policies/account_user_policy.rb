class AccountUserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    current_account_user.has_permission?("user", "index")
  end

  def show?
    current_account_user.has_permission?("user", "show")
  end

  def create?
    current_account_user.has_permission?("user", "create")
  end

  def update?
    current_account_user.has_permission?("user", "update")
  end

  def destroy?
    current_account_user.has_permission?("user", "destroy")
  end

  def restore?
    current_account_user.has_permission?("user", "restore")
  end

  def role?
    current_account_user.has_permission?("user", "role")
  end
end
