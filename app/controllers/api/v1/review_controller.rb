class Api::V1::ReviewController < ApplicationController
  before_action :set_story, only: [:create, :see]
  before_action :set_review, only: [:edit, :destroy]

  # POST 
  def create
    if @story.state
      @review = Review.new(
        review: review_params[:content],
        story: @story,
        state: true,
        user: @current_user
      )
      if @review.save
        render json: { review: @review }, status: :created
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Story no founded' }, status: :unprocessable_entity
    end
  end

  # PUT 
  def edit
    if @review.state
      @review.update(review: review_params[:content])
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE 
  def destroy
    if @review.update(state: false)
      render json: { message: "review successfully deleted" }, status: :ok
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # GET 
  def see
    reviews = Reviews.where(state: true, story_id: @story).includes(:reports)
    if reviews.present?
      response = reviews.as_json(include: {
        reports: { only: [:id, :report, :comment, :state] }
      })
      render json: response, status: :ok
    else
      render json: { error: 'No reviews found for the current user' }, status: :not_found
    end
  end

  private
  def set_story
    @story = Story.find(params[:story_id])
    render json: { error: 'Story not found' }, status: :not_found unless @story
  end

  def set_review
    @review = Review.find(params[:id])
    render json: { error: 'Review not found' }, status: :not_found unless @review
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:content)
  end
end
