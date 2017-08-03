describe StripeWrapper::Charge do
  describe ".create" do
    let(:valid_token) do
      stripe_create_token("4242424242424242")
    end

    let(:invalid_token) do
      stripe_create_token("4000000000000002")
    end

    it "successfully charges card", :vcr do
      expect(stripe_wrapper_response(valid_token)).to be_successful
    end

    it "makes a decline charge", :vcr do
      expect(stripe_wrapper_response(invalid_token)).not_to be_successful 
    end

    it "returns error message", :vcr do
      message = stripe_wrapper_response(invalid_token).error_message
      expect(message).to eq("Your card was declined.")
    end
  end
end