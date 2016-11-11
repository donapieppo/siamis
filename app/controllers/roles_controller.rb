class RolesController < ApplicationController

  def destroy
    @role = Role.find(params[:id])
    current_user.owns!(@role)
    @role.destroy
    redirect_to @role.conference_session, notice: 'OK'
  end

  private 

  def role_params
    par = params[:author] || params[:organizer] || params[:chair]
    par.permit(:email, :name, :surname, :affiliation, :address)
  end

end

