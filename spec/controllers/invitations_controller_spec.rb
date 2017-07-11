describe InvitationsController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets invitation instance" do
      set_current_user
      get :new
      expect(assigns[:invitation]).to be_a_new Invitation
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "valid inputs" do
      let(:user) { Fabricate(:user) }
      let(:invitation) { Fabricate.attributes_for(:invitation) }

      before do
        set_current_user(user)
        post :create, invitation: invitation
      end
      
      after { ActionMailer::Base.deliveries.clear }

      it "redirects to invitation page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq 1
      end
      
      it "sends email to recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [invitation["recipient_email"]]
      end
      
      it "flashes success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "invalid inputs" do
      let(:user) { Fabricate(:user) }
      let(:invitation) { Fabricate.attributes_for(:invitation, recipient_name: nil) }
      
      before do
        set_current_user(user)
        post :create, invitation: invitation
      end
      
      after { ActionMailer::Base.deliveries.clear }
      
      it "renders new template" do
        expect(response).to render_template :new
      end

      it "does not create @invitation" do
        expect(Invitation.count).to eq 0
      end

      it "does not send email" do
        expect(ActionMailer::Base.deliveries).to eq []  
      end

      it "sets errors" do
        errors = assigns[:invitation].errors.full_messages
        expect(errors.length).not_to eq 0 
      end
    end
  end
end