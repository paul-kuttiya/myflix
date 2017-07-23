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
    context "user successfully sign up" do
      let(:result) { double(:result, successful?: true, user: Fabricate(:user))}

      before do
        allow_any_instance_of(UserSignup).to receive(:signup) { result }
        post :create, 
        user: Fabricate.attributes_for(:user)
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
    
    context "failed user sign up" do
      let(:result) do 
        double(:result, 
        successful?: false, 
        error_message: "Your card is decline!")
      end

      before do
        allow_any_instance_of(UserSignup).to receive(:signup) { result }
        post :create, 
        user: Fabricate.attributes_for(:user)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
      
      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
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