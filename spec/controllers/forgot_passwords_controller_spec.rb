describe ForgotPasswordsController do
  describe "POST create" do
    context "invalid input" do
      before do
        post :create, email: nil
      end

      it "flashes message" do
        expect(flash[:danger]).to eq "Invalid inputs!"
      end

      it "redirects to forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
    end

    context "existing email" do
      let(:user) { Fabricate(:user) }

      before do  
        post :create, email: user.email
      end

      it "generates token" do
        user.reload
        expect(user.token).not_to be_nil
      end

      it "sends email to email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
      end
      
      it "redirects to password reset confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end
    end
    
    context "non existing email" do
      before do  
        post :create, email: 'not_exist@email.com'
      end

      it "flash message" do
        expect(flash[:danger]).to eq "Email does not exist"
      end

      it "redirects to forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
    end
  end
end
