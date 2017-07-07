describe RelationshipsController do
  describe "GET index" do
    it "sets @relationship to array of relationships which user is following" do
      user = Fabricate(:user)
      leader = Fabricate(:user)
      set_current_user(user)
      relationship = Fabricate(:relationship, leader: leader, follower: user)

      get :index
      expect(assigns[:relationships]).to eq [relationship]
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    context "user" do
      let(:user) { Fabricate(:user) }
      let(:leader) { Fabricate(:user) }
      let(:relationship) { Fabricate(:relationship, leader: leader, follower: user) }
      
      before do
        set_current_user(user)
      end
      
      it "deletes follower relationship for following user" do
        delete :destroy, { id: relationship.id }
        expect(Relationship.count).to eq 0
      end

      it "redirects to people page" do
        delete :destroy, { id: relationship.id }
        expect(response).to redirect_to people_path
      end

      it "does not delete relationship if user is not a follower" do
        relationship = Fabricate(:relationship, follower_id: 2, leader: leader)

        delete :destroy, { id: relationship.id }
        expect(Relationship.count).to eq 1
      end
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    context "signed in user" do 
      let(:user) { Fabricate(:user) }

      before do
        set_current_user(user)
      end
      
      it "redirects to people page" do
        leader = Fabricate(:user)
        
        post :create, { leader_id: leader.id }
        expect(response).to redirect_to people_path
      end

      it "creates relationship for a user to follow leader" do
        leader = Fabricate(:user)

        post :create, { leader_id: leader.id }
        expect(Relationship.count).to eq 1
      end

      it "does not follow the same user twice" do
        leader = Fabricate(:user)
        relationship = Fabricate(:relationship, leader: leader, follower: user)

        post :create, { leader_id: leader.id }
        expect(Relationship.count).to eq 1
      end

      it "does not follow itself" do
        post :create, { leader_id: user.id }
        expect(Relationship.count).to eq 0
      end
    end
  end
end