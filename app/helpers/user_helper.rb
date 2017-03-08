module UserHelper
  def current_user_owns?(what)
    current_user and current_user.owns?(what)
  end

  def current_user_owns!(what)
    current_user_owns?(what) or raise "NotAuthorized"
  end

  def user_master_of_universe?
    current_user and current_user.master_of_universe?
  end

  def user_master_of_universe!
    user_master_of_universe? or raise NoAccess
  end

  def user_in_organizer_committee?
    current_user and current_user.in_organizer_committee?
  end

  def user_in_organizer_committee!
    user_in_organizer_committee? or raise NoAccess
  end

  def user_in_scientific_committee?
    current_user and current_user.in_scientific_committee?
  end

  def user_in_scientific_committee!
    user_in_scientific_committee? or raise NoAccess
  end

  def true_user_can_impersonate?
    true_user and Rails.configuration.impersonate_admins and Rails.configuration.impersonate_admins.include?(true_user.email)
  end
end

