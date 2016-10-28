class RolesController < ApplicationController

  def destroy
    @role = Role.find(params[:id])
    current_user.owns!(@role)
    @role.destroy
    redirect_to @role.conference_session, notice: 'OK'
  end

  private 

  def roles_params
    p = (params[:author] || params[:organizer])
    if what = @minisymposium || @minitutorial || @presentation
      p[:conference_session_id] = what.id
    end
    p.permit(:email, :name, :surname, :affiliation, :address, :conference_session_id)
  end

end

