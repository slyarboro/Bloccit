class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    # @question = Question.new
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.resolved = params[:question][:resolved]

    @question = Question.new(params.require(:question).permit(:title, :body, :resolved))

    if @question.save
      flash[:notice] = "Question saved successfully."
      redirect_to @question
    else
      flash[:error] = "There was an error saving your question. Try again, if you please!"
      render :new
    end
  end


  def edit
    @question = Question.find(params[:id])
  end


  def update
    # @question = Question.find(params[:id])
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.resolved = params[:question][:resolved]
    @question = Question.find(params[:id])

    if @question.update_attributes(params.require(:question).permit(:title, :body, :resolved))
      flash[:notice] = "Question updated successfully."
      redirect_to @question
    else
      flash[:error] = "There was an error saving your question. Try again, if you wish!"
      render :edit
    end
  end

  def destroy
    @question = Question.find(params[:id])

    if @question.destroy
      flash[:notice] = "\"#{@question.title}\ was deleted successfully."
      redirect_to questions_path
    else
      flash[:error] = "Your question was unable to be deleted."
      render :show
    end
  end
end
