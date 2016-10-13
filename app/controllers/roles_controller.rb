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

  def set_minisymosium_and_minitutorial_and_presentation
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
    @presentation  = Presentation.find(params[:presentation_id]) if params[:presentation_id]
  end

end

