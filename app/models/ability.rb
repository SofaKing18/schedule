# cancancan class Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :read, UserEvent
    else
      can [:read, :create], UserEvent
      can [:update, :destroy], UserEvent, user_id: user.id
    end
  end
end
