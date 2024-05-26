class Api::V1::ReportController < ApplicationController
    before_action :set_review, only: [:create, :index_by_review]
    before_action :set_story, only: [:index_by_story]
    before_action :set_report, only: [:destroy]
  
    # POST /api/v1/reports
    def create
      @report = @review.reports.build(report_params.merge(state: true))
  
      if @report.save
        render json: @report, status: :created
      else
        render json: @report.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/v1/reports/:id
    def destroy
      if @report.update(state: false)
        render json: { message: 'Report succesfully delete' }, status: :ok
      else
        render json: @report.errors, status: :unprocessable_entity
      end
    end
  
    # GET /api/v1/reviews/:review_id/reports
    def index_by_review
      @reports = @review.reports
      if @reports
        render json: @reports
      else 
        render json: {message: "No Reports Found for this Review"}, status: :not_found
      end
    end
  
    # GET /api/v1/stories/:story_id/reports
    def index_by_story
      @reports = Report.joins(:review).where(reviews: { story_id: @story.id })
      if @reports.empty?
        render json: {message: "No Reports Found for this Story"}, status: :not_found
      else
        render json: @reports
      end 
    end
  
    private
    def set_review
      @review = Review.find(params[:review_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Review not found' }, status: :not_found
    end
  
    def set_story
        @story = Story.find_by(id: params[:story_id], state: true)
        if @story.nil?
          render json: { error: 'Story not found' }, status: :not_found
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Story not found' }, status: :not_found
    end
  
    def set_report
      @report = Report.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Report not found' }, status: :not_found
    end
  
    def report_params
      params.require(:report).permit(:report, :comment)
    end
end
  