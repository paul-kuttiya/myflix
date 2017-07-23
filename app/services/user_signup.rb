class UserSignup
  attr_reader :error_message, :user
  
  def initialize(user)
    @user = user
  end
  
  def signup(invitation, stripe_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :source => @stripe_token,
        :description => "Charge for #{@user.email}"
      )

      if charge.successful?
        @user.save
        AppMailer.delay.send_welcome_email(@user.id)
        handle_invitation(invitation)
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
      @error_message = "Invalid user info please check the errors"
    end
    self
  end

  def successful?
    @status == :success
  end

  private
  def handle_invitation(invitation)
    if invitation
      @invitation = invitation
      inviter = @invitation.inviter
      @user.follow(inviter)
      inviter.follow(@user)
      @invitation.update_column(:token, nil)
    end
  end
end