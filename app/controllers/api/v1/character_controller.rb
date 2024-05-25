class Api::V1::CharacterController < ApplicationController
    before_action :set_character, only: [:update, :destroy] 
    def create
        prompt = generate_prompt(character_params)
        response = ChatGPTService.new(message: prompt).call(:tp_create_character)
                
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

    def user_characters
        characters = @current_user.characters
    
        if characters.present?
          render json: characters, status: :ok
        else
          render json: { error: 'No characters found for the current user' }, status: :not_found
        end
    end
    

    def update
        if @character.update(character_params)
          # Solo generar un nuevo prompt si hay cambios en los campos relevantes
          if character_params.keys.any? { |key| %i[name birth_date context appearance outfit personality history powers hobbies fears goals relationships enemies allies other].include?(key.to_sym) }
            prompt = generate_prompt(character_params)
            response = ChatGPTService.new(message: prompt).call(:tp_create_character)
            @character.update(description: response)
          end
          render json: { character: @character }, status: :ok
        else
          render json: { errors: @character.errors }, status: :unprocessable_entity
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
    def set_character
      if @character = current_user.characters.find(params[:id])
      else
        render json: { error: "Character no found" }, status: :not_found
    end

    def character_params
        params.require(:character).permit(:name, :birth_date, :context, :appearance, :outfit, :personality, :history, :powers, :hobbies, :fears, :goals, :relationships, :enemies, :allies, :other)
    end
    
    def generate_prompt(character_params)
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
        un personaje único. Trata de ser detallado pero conciso no necesito historias detalladas solo el personaje."

        prompt
    end

      
end