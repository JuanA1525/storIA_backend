class Api::V1::StoryController < ApplicationController
  before_action :set_story, only: [:update, :destroy, :show]

  def create
    # Check if characters were provided for the story
    unless params[:characters].present?
      return render json: { error: 'Must provide at least one character for the story' }, status: :unprocessable_entity
    end

    # Check if the provided characters exist and are associated with the current user
    characters = Character.where(id: params[:characters], state: true).where(user_id: @current_user.id)
    if characters.count != params[:characters].count
      return render json: { error: 'Not all provided characters were found or are not associated with the current user' }, status: :unprocessable_entity
    end
    
    # Generate the prompt for the story
    prompt = generate_prompt(story_params, characters)
    response = ChatGPTService.new(message: prompt).call(:tp_create_story)

    # Create the story with the title, content and characters provided
    story = Story.new(
      title: story_params[:title],
      content: response,
      state: true,
      user: @current_user
    )

    # Save history to database
    if story.save
      # Create relationships between story and characters
      characters.each do |character|
        StoryCharacter.create(story: story, character: character)
      end
      render json: { story: story }, status: :created
    else
      render json: { errors: story.errors }, status: :unprocessable_entity
    end
  end



  # observe all user stories
  def index
    stories = @current_user.stories.where(state: true)
    if stories.present?
      # Load the characters, reviews, and reports associated with each story
      stories_with_associations = stories.includes(characters: {}, reviews: :reports)

      # Map response
      response = stories_with_associations.as_json(include: {
        characters: { only: [:id, :name, :description, :state] },
        reviews: { 
          only: [:id, :review, :user_id, :state], 
          include: {
            reports: { only: [:id, :report,:comment, :state] }
          }
        }
      })

      # Filter out characters with state != true
      response.each do |story|
        story["characters"].select! { |character| character["state"] }

        story["reviews"].each do |review|
          # Filter out reports with state != true
          review["reports"].select! { |report| report["state"] }
        end
      end
      render json: response, status: :ok
    else
      render json: { error: 'No stories found for current user' }, status: :not_found
    end
  end
  


  # observe the information of a specific story
  def show
    if @story && @story.state
      characters = @story.characters
      response = {
        story: @story,
        characters: characters
      }
      render json: response, status: :ok
    else
      render json: { error: 'History not found' }, status: :not_found
    end
  end


  def update
    if @story.state && @story.update(story_params)
      render json: { story: @story }, status: :ok
    else
      render json: { errors: @story.errors }, status: :unprocessable_entity
    end
  end


  def destroy
    if @story.update(state: false)
      render json: { message: "story successfully deleted" }, status: :ok
    else
      render json: { errors: @story.errors }, status: :unprocessable_entity
    end
  end



  private
  def set_story
    @story = @current_user.stories.find_by(id: params[:id])
    render json: { error: 'History not found' }, status: :not_found unless @story
  end

  def story_params
    params.require(:story).permit(:title, :content)
  end

  def generate_prompt(story_params, characters)
    prompt = "Crea una historia con los siguientes detalles:\n"

    prompt << "Título: #{story_params[:title]}\n" if story_params[:title].present?
    prompt << "Contenido: #{story_params[:content]}\n" if story_params[:content].present?

    characters.each do |character|
      prompt << "Personaje: #{character.name}\n"
      prompt << "Descripción: #{character.description}\n"
    end

    prompt << "Agrega más detalles o información relevante para completar la historia."

    prompt
  end
end
