class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]
  
    def index
      @tasks = Task.all
      @task = Task.new
    end
  
    def show
    end
  
    def new
      @task = Task.new
    end
  
    def create
        @task = Task.new(task_params)
    
        respond_to do |format|
          if @task.save
            format.turbo_stream { render turbo_stream: turbo_stream.append('tasks', partial: 'tasks/task', locals: { task: @task }) }
          else
            format.html { render :new }
            format.turbo_stream { render turbo_stream: turbo_stream.replace('new_task', partial: 'tasks/form', locals: { task: @task }) }
          end
        end
    end

    def edit
    end
  
    def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@task) }
          end
        else
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@task, partial: 'tasks/form', locals: { task: @task }) }
          end
        end
      end
      

    def destroy
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
  