describe UserSignup do
  describe "#sign_up" do
    context "valid user info and valid card" do
      let(:charge) { double(:charge, successful?: true) }
      
      before do
        expect(StripeWrapper::Charge).to receive(:create) { charge }
      end
      
      it "creates user" do
        UserSignup.new(Fabricate.build(:user)).signup(nil, 'stripe_token')

        expect(User.count).to eq(1)
      end

      it "sends email to the user with valid input" do
        UserSignup.new(Fabricate.build(:user, email: 'john@example.com')).signup(nil, 'stripe_token')

        expect(ActionMailer::Base.deliveries.last.to).to eq ['john@example.com']
      end

      it "sends email to valid input user with user full name" do
        UserSignup.new(Fabricate.build(:user, email: 'john@example.com', full_name: 'john doe')).signup(nil, 'stripe_token')

        expect(ActionMailer::Base.deliveries.last.body).to include "john doe"
      end

      context "invited sign up" do
        let(:inviter) { Fabricate(:user) }

        let(:invitation) { Fabricate(:invitation, 
        recipient_email: 'joe@example.com', 
        inviter: inviter) }
        
        let(:invited_user) { User.find_by(email: 'joe@example.com') }
        
        before do
          UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).signup(invitation, 'stripe_token')
        end

        it "sets invited user to follow inviter, and inviter follows invited user" do
          expect(invited_user.follow?(inviter)).to eq true
          expect(inviter.follow?(invited_user)).to eq true
        end

        it "deletes token" do
          invitation.reload
          expect(invitation.token).to be_nil
        end
      end
    end

    context "valid user info and decline card" do
      it "does not create a new user" do
        charge = double(:charge, 
        successful?: false,
        error_message: "Your card is decline!"
        )
        
        expect(StripeWrapper::Charge).to receive(:create) { charge }

        UserSignup.new(Fabricate.build(:user)).signup(nil, 'stripe_token')

        expect(User.count).to eq 0
      end
    end

    context "invalid users info" do
      before do
        UserSignup.new(Fabricate.build(:user, email: nil)).signup(nil, 'stripe_token')
      end

      it "does not create user" do
        expect(User.count).to be(0)
      end

      it "does not send email with invalid inputs" do
        expect(ActionMailer::Base.deliveries).to eq []   
      end

      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end
  end
end