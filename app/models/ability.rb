class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user

    can :accept, Answer do |answer|
      user.owner?(answer.question)
    end

    can :vote_up, [Question, Answer] do |resource|
      user.can_vote?(resource)
    end

    can :vote_down, [Question, Answer] do |resource|
      user.can_vote?(resource)
    end

    can :unvote, [Question, Answer]
  end
end
