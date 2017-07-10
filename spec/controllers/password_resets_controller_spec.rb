describe PasswordResetsController do
  describe "GET show" do
    it "renders show template for valid token" do
      user = Fabricate(:user, token: '12345')
      get :show, id: user.token
      expect(response).to render_template :show
    end
    
    it "sets token" do
      user = Fabricate(:user, token: '12345')
      get :show, id: user.token
      expect(assigns[:token]).to eq '12345'
    end

    it "redirects to token expire page for invalid token" do
      get :show, id: '22222'
      expect(response).to redirect_to expired_token_path
    end
  end
  describe "POST create" do
    context "valid token" do
      let(:user) { Fabricate(:user, token: "12345", password: 'old_password') }

      before do
        post :create, token: user.token, password: 'new_password'
        user.reload
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      
      it "resets password" do
        expect(user.authenticate('new_password')).to eq user
      end
      
      it "flashes message" do
        expect(flash[:success]).to be_present
      end

      it "it deletes token" do
        expect(user.token).to be_nil
      end
    end
    
    context "invalid token" do
      it "redirect to expired token path" do
        user = Fabricate(:user, token: "12345", password: 'old_password')
        post :create, token: '11111', password: 'new_password'

        user.reload
        expect(response).to redirect_to expired_token_path
      end 
    end
  end
end