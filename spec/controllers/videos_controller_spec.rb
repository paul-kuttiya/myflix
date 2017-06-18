describe VideosController do
  describe 'GET show' do
    it 'sets @video for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get 'show', id: video.id

      expect(assigns[:video]).to eq(video)
    end

    it 'redirects to sign in path for unauthenticated user' do
      video = Fabricate(:video)
      get 'show', id: video.id

      expect(response).to redirect_to sign_in_path
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

    it 'redirects for unauthenticated users' do
      get :search, query: "video"

      expect(response).to redirect_to sign_in_path
    end
  end
end