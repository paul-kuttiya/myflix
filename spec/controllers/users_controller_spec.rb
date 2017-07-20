describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns[:user]).to be_instance_of(User)
    end

    it "redirects user if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid users" do
      before do
        allow(StripeWrapper::Charge).to receive(:create)
        post :create, user: {full_name: 'abc', email: 'abc@gg.com', password: '1234'}
      end

      it "saves user" do
        expect(User.count).to eq(1)
      end

      context "invited user" do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, 
        recipient_email: 'joe@example.com', 
        inviter: inviter) }

        before do
          allow(StripeWrapper::Charge).to receive(:create)
          post :create, 
          user: {email: 'joe@example.com', password: 'password', full_name: 'joe dow'}, 
          invitation_token: invitation.token
        end

        it "sets invited user to follow inviter" do
          invited_user = User.find_by(email: 'joe@example.com')
          expect(invited_user.follow?(inviter)).to eq true
        end
      
        it "sets inviter to follow invited user" do
          invited_user = User.find_by(email: 'joe@example.com')
          expect(inviter.follow?(invited_user)).to eq true
        end
        
        it "deletes token" do
          invitation.reload
          expect(invitation.token).to be_nil
        end
      end
    
      it "stored user in session" do
        expect(session[:user_id]).not_to be_nil
      end

      it "shows notification" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end
  
    context "invalid users" do
      before do
        post :create, user: {email: 'abc@gg.com', password: '1234'}
      end

      it "sets user" do
        expect(assigns[:user]).to be_instance_of(User)
      end

      it "does not create user" do
        expect(User.count).to be(0)
      end

      it "render new template" do
        expect(response).to render_template :new
      end
      
      it "shows error" do
        errors = assigns[:user].errors.full_messages.length
        expect(errors).not_to be(0)
      end
    end

    context "sending emails" do
      before do
        allow(StripeWrapper::Charge).to receive(:create)
      end
      
      it "sends email to the user with valid input" do
        user = Fabricate.attributes_for(:user)
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.to).to eq [user["email"]]
      end

      it "sends eamil to valid input user with user full name" do
        user = Fabricate.attributes_for(:user)
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.body).to include user["full_name"]
      end

      it "does not send email with invalid inputs" do
        post :create, user: { email: 'abc@gmail.com' }
        expect(ActionMailer::Base.deliveries).to eq []   
      end
    end
  end

  describe "GET show" do
    context "non user" do
      it_behaves_like "requires sign in" do
        let(:action) { get :show, id: 1 }
      end
    end

    context "user" do
      it "sets user" do
        user = Fabricate(:user)
        set_current_user(user)
        get :show, id: user.id
        expect(assigns[:user]).to eq user
      end
    end
  end

  describe "GET register_with_invitation" do
    context "valid invitation token" do
      let(:invitation) { Fabricate(:invitation) }
      
      before do
        get :register_with_invitation, token: invitation.token 
      end
      
      it "render new template" do
        expect(response).to render_template :new
      end

      it "sets @user with recipient's email" do
        expect(assigns[:user].email).to eq invitation.recipient_email
      end
      
      it "sets @token" do
        expect(assigns[:invitation_token]).to eq invitation.token
      end
    end

    context "invalid token" do
      it "redirects to expired page" do
        get :register_with_invitation, token: '12345'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end