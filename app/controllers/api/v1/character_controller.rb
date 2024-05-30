class Api::V1::CharacterController < ApplicationController
  before_action :set_character, only: [:act_like, :destroy, :update, :show] 
  before_action :set_lenguage, only: [:create, :act_like]

  # create a character
  def create
      prompt = generate_prompt(character_params,  @lenguage)
      response = ChatGPTService.new(message: prompt).call(:tp_create_character, @lenguage)
              
      character = Character.new(
          name: character_params[:name],
          description: response,
          state: true,
          user: @current_user
      )

      if character.save
          render json: { character: character}
      else
          render json: { errors: character.errors }, status: :unprocessable_entity
      end
  end    

  # act like a character
  def act_like
    if @character.state == true
      response = ChatGPTService.new(message: params[:text]).call(:tp_actlike, @character.description, @lenguage)
      render json: { response: response }, status: :ok
    else
      render json: { error: 'Character not found' }, status: :not_found
    end
  end

  # observe all user characters
  def index
    characters = @current_user.characters.where(state: true)
    if characters.present?
      render json: characters, status: :ok
    else
      render json: { error: 'No characters found for the current user' }, status: :not_found
    end
  end

  # observe the information of a specific character
  def show
    if @character.state==true
      render json: @character, status: :ok
    else
      render json: { error: 'Character not found' }, status: :not_found
    end
  end

  # update a character
  def update
    if @current_user.characters.find_by(id: params[:id]) and @character.state == true
      if @character.update(character_params_update)
        render json: { character: @character }, status: :ok
      else
        render json: { errors: @character.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Character not found' }, status: :forbidden
    end
  end


  def destroy
    if @character.update(state: false)
      render json: { message: "Character eliminated successfully" }, status: :ok
    else
      render json: { errors: @character.errors }, status: :unprocessable_entity
    end
  end
  
  private

  def set_lenguage
    if params[:len] == "es"
      @lenguage = "español"
    elsif params[:len] == "en"
      @lenguage = "english"
    else
      render json: { error: "Lenguage not found" }, status: :not_found
    end
  end

  def set_character
    @character = Characters.find_by(id: params[:id])
    render json: { error: "Character not found" }, status: :not_found unless @character
  end

  def character_params
      params.require(:character).permit(:name, :birth_date, :context, :appearance, :outfit, :personality, :history, :powers, :hobbies, :fears, :goals, :relationships, :enemies, :allies, :other)
  end

  def character_params_update
    params.require(:character).permit(:name, :description)
  end
  
  def generate_prompt(character_params, lenguage = nil)
      prompt = "Crea un personaje con las siguientes características:\n"
      
      prompt << "Nombre: #{character_params[:name]}\n" if character_params[:name].present?
      prompt << "Fecha de Nacimiento: #{character_params[:birth_date]}\n" if character_params[:birth_date].present?
      prompt << "Contexto: #{character_params[:context]}\n" if character_params[:context].present?
      prompt << "Apariencia: #{character_params[:appearance]}\n" if character_params[:appearance].present?
      prompt << "Outfit: #{character_params[:outfit]}\n" if character_params[:outfit].present?
      prompt << "Personalidad: #{character_params[:personality]}\n" if character_params[:personality].present?
      prompt << "Historia: #{character_params[:history]}\n" if character_params[:history].present?
      prompt << "Poderes: #{character_params[:history]}\n" if character_params[:powers].present?
      prompt << "Pasatiempos: #{character_params[:hobbies]}\n" if character_params[:hobbies].present?
      prompt << "Miedos: #{character_params[:fears]}\n" if character_params[:fears].present?
      prompt << "Objetivos: #{character_params[:goals]}\n" if character_params[:goals].present?
      prompt << "Relaciones: #{character_params[:relationships]}\n" if character_params[:relationships].present?
      prompt << "Enemigos: #{character_params[:enemies]}\n" if character_params[:enemies].present?
      prompt << "Aliados: #{character_params[:allies]}\n" if character_params[:allies].present?
      prompt << "Otros Detalles: #{character_params[:other]}\n" if character_params[:other].present?
      
      prompt << "Agrega informacion que creas que haga falta para completar el personaje. Deja volar tu imaginación y crea
      un personaje único. Trata de ser detallado pero conciso no necesito historias detalladas solo el personaje. \nResponde en el idioma: #{lenguage}."

      prompt
  end
end