class Api::V1::CharacterController < ApplicationController
    
    def create
        puts("----> Current User in CharController: #{@current_user.inspect}")
        puts("----> Current User.id in CharController: #{@current_user.id}")
        prompt = generate_prompt(character_params)
        response = ChatGPTService.new(message: prompt).call(:tp_create_character)
        
        character = Character.new(
            name: character_params[:name],
            description: response,
            state: true,
            user: @current_user
        )

        if character.save
            render json: { character: character, ai_response: response }
        else
            render json: { errors: character.errors }, status: :unprocessable_entity
        end
    end
    
    private
    
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