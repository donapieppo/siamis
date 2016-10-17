class RolesController < ApplicationController

  def destroy
    @role = Role.find(params[:id])
    current_user.owns!(@role)
    @role.destroy
    redirect_to @role.what_for, notice: 'OK'
  end

  private 

  def roles_params
    p = (params[:author] || params[:organizer])
    p[:minisymposium_id] = @minisymposium.id if @minisymposium
    p[:minitutorial_id]  = @minitutorial.id if @minitutorial
    p.permit(:email, :name, :surname, :affiliation, :address, :minisymposium_id, :minitutorial_id)
  end

end

