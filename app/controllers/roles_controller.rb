# see subclasses authors/organizers
class RolesController < ApplicationController

  def destroy
    @role = Role.find(params[:id])
    current_user.owns!(@role)
    # can't delete yourself
    if @role.user == current_user
      redirect_to @role.relative_to, alert: 'It is not possible to delete yourself. Please contact organizing committee.'
    else
      @role.destroy
      redirect_to @role.relative_to, notice: 'OK'
    end
  end

  private 

  def role_params
    par = params[:author] || params[:organizer] 
    par.permit(:email, :name, :surname, :affiliation, :address)
  end

end

