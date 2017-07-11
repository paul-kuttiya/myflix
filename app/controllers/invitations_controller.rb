class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(create_invitation.merge!(inviter_id: current_user.id))
    
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "You send invite to #{@invitation.recipient_email}"
      redirect_to new_invitation_path
    else
      render :new
    end
  end

  private
  def create_invitation
    params.require(:invitation).permit!
  end
end