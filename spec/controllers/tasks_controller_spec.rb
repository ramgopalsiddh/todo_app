require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  render_views  # Ensure views are rendered

  let!(:task) { create(:task, title: 'Test Task', description: 'This is a test task', due_date: '2024-12-31') }
  let(:valid_attributes) { { title: 'Test Task', description: 'This is a test task', due_date: '2024-12-31', completed: false } }
  let(:invalid_attributes) { { title: '', description: '', due_date: '', completed: nil } }

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
        put :update, params: { id: task.id, task: valid_attributes }, format: :turbo_stream
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
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe "PATCH #toggle" do
    it "toggles the task's completion status" do
      patch :toggle, params: { id: task.id, completed: true }
      task.reload
      expect(task.completed).to be_truthy
    end

    it "returns a success message" do
      patch :toggle, params: { id: task.id, completed: true }
      expect(response.body).to include("Success")
    end
  end
end
