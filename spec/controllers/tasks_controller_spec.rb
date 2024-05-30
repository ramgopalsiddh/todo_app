require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  include Devise::Test::ControllerHelpers
  
  before do
    @user = FactoryBot.create(:user, confirmed_at: Time.now)
    sign_in @user
  end

  render_views 

  let(:valid_attributes) { { title: 'Test Task', description: 'This is a test task', due_date: '2024-12-31', completed: false, user_id: @user.id } }
  let(:invalid_attributes) { { title: '', description: '', due_date: '', completed: nil, user_id: @user.id } }
  let!(:task) { FactoryBot.create(:task, user: @user, title: 'Test Task', description: 'This is a test task', due_date: '2024-12-31', completed: false) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:tasks)).to eq([task])
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the tasks list" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(tasks_path)
      end

      it "returns a turbo stream response" do
        post :create, params: { task: valid_attributes }, format: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream].to_s
      end
    end

    context "with invalid params" do
      before do
        allow(controller).to receive(:render).and_call_original
        allow(controller).to receive(:render).with(:new) # Stub rendering of the 'new' template
      end

      it "does not create a new Task" do
        expect {
          post :create, params: { task: invalid_attributes }
        }.not_to change(Task, :count)
      end

      it "returns a turbo stream response" do
        post :create, params: { task: invalid_attributes }, format: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream].to_s
        expect(response.body).to include('<turbo-stream action="replace" target="new_task">') # Ensure turbo stream response
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { title: 'Updated Task', description: 'This is an updated test task' } }

      it "updates the requested task" do
        put :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq('Updated Task')
        expect(task.description).to eq('This is an updated test task')
      end

      it "responds successfully with turbo stream" do
        put :update, params: { id: task.id, task: new_attributes }, format: :turbo_stream
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "does not update the task" do
        put :update, params: { id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).not_to eq('')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_url)
    end

    it "returns a turbo stream response" do
      delete :destroy, params: { id: task.id }, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream].to_s
    end
  end

  describe "PATCH #toggle" do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }

    context "when toggling the task's completion status to true" do
      it "renders Turbo Stream response and toggles the completion status" do
        patch :toggle, params: { id: task.id, completed: true }, format: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(task.reload.completed).to eq(true)
      end
    end

    context "when toggling the task's completion status to false" do
      it "renders Turbo Stream response and toggles the completion status" do
        patch :toggle, params: { id: task.id, completed: false }, format: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(task.reload.completed).to eq(false)
      end
    end

    context "when responding with a success message" do
      it "renders a success message as JSON" do
        patch :toggle, params: { id: task.id, completed: true }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)["message"]).to eq("Success")
      end
    end
  end
end
