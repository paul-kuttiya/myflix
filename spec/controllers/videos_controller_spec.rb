describe VideosController do
  describe 'GET show' do
    it 'sets @video for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get 'show', id: video.id

      expect(assigns[:video]).to eq(video)
    end

    it_behaves_like "requires sign in" do
      let(:action) {get 'show', id: 3}
    end

    it 'has @video reviews array for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns[:video].reviews).to eq([review2, review1])
    end
  end

  describe "GET search" do
    it 'sets @videos for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'video')
      get :search, query: "vid"

      expect(assigns[:videos]).to eq([video])
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :search, query: "video"}
    end
  end
end