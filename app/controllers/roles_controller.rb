class RolesController < ApplicationController

  def destroy
    @role = Role.find(params[:id])
    current_user.owns!(@role)
    @role.destroy
    redirect_to [:edit, @role.minitutorial || @role.minisymposium], notice: 'OK'
  end

  private 

  def roles_params
    p = (params[:speaker] || params[:organizer])
    p[:minisymposium_id] = @minisymposium.id if @minisymposium
    p[:minitutorial_id]  = @minitutorial.id if @minitutorial
    p.permit(:email, :name, :surname, :affiliation, :address, :minisymposium_id, :minitutorial_id)
  end

end

