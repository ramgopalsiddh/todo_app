class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]
  
    def index
      @tasks = Task.order(:due_date)
      @task = Task.new
    end
  
    def show
    end
  
    def new
      @task = Task.new
    end
  
    def create
      @task = Task.new(task_params)
  
      if @task.save
        redirect_to tasks_path
        flash[:notice] = 'Task was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end
  
    def update
      if @task.update(task_params)
        flash[:notice] = "Task was updated sucessfully"
        redirect_to tasks_path
      else
        render :edit
      end
    end

    def destroy
        @task = Task.find(params[:id])
        @task.destroy
        respond_to do |format|
          format.html { redirect_to tasks_url }
          format.turbo_stream # Render turbo-stream response
        end
      end

    def toggle
        @task = Task.find(params[:id])
        @task.update(completed: params[:completed])
    
        render json: { message: "Success" }
      end

    private

    def set_task
      @task = Task.find(params[:id])
    end
  
    def task_params
      params.require(:task).permit(:description, :due_date, :title, :completed)
    end
  end
  