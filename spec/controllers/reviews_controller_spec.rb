describe ReviewsController do
  describe "POST create" do
    context "signed in user" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      context "valid inputs" do
        let(:video) {Fabricate(:video)}
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        
        it "creates review for a video" do
          expect(Review.first.video).to eq(video)
        end

        it "redirects to video page" do
          expect(response).to redirect_to video
        end

        it "has new review" do
          expect(Review.count).to eq(1)
        end

        it "has user for review" do
          expect(Review.first.user).not_to be_nil
        end
      end

      context "invalid input" do
        let(:video) {Fabricate(:video)}
        before do
          post :create, review: {ratings: 4}, video_id: video.id
        end

        it "does not create review" do
          expect(Review.count).to eq(0)
        end

        it "render video view" do
          expect(response).to render_template "videos/show"
        end

        it "sets video" do
          expect(assigns[:video]).to eq(video)
        end

        it "sets review" do
          review = Fabricate(:review, video: video)
          expect(assigns[:video].reviews).to match_array([review])
        end
      end
    end
    context "user not signed in" do
      it_behaves_like "requires sign in" do
        let(:action) {post :create, review: Fabricate.attributes_for(:review), video_id: 1}
      end
    end
  end
end