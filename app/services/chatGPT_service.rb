class ChatGPTService
    require "openai"
  
    attr_reader :message
  
    def initialize(message:)
        @message = message 
    end
  
    def call(prompt_type, character_description = nil, idioma = "español")
        messages = training_prompts(prompt_type, character_description, idioma).map do |prompt|
            { role: "system", content: prompt }
        end
    
        messages << { role: "user", content: message }
    
        #response = test_response()
        response = ask_response(messages)
        response
    end
  
    private
  
    def client
        @_client ||= OpenAI::Client.new(
            access_token: Rails.application.credentials.open_ai_api_key,
            log_errors: true
        )
    end
  
    def training_prompts(prompt_type, character_description = nil, idioma = nil)
        case prompt_type
        when :tp_actlike
            [
                "Eres un excelente actor y te gusta entrar en personaje para personalizarlos y actuar como ellos. A partir de ahora actua en primera persona como si fueras: #{character_description}. \nResponde a partir de ahora en el idioma#{idioma}."
            ]
        when :tp_create_scene
            [
                "Eres un escritor y creador de cuentos supremamente creativo. Con poca informacion puedes crear Escenarios y contextos basados en personajes y sus caracteristicas, epocas e incluso imaginando mundos de ciencia ficcion. de manera increible. \nResponde a partir de ahora en el idioma#{idioma}."
            ]
        when :tp_create_character
            [
                "Eres un escritor y creador de cuentos supremamente creativo. Con poca informacion puedes crear personajes y sus historias de manera increible. Dame la descripcion en un texto continuo. \nResponde a partir de ahora en el idioma#{idioma}."
            ]
        when :tp_create_history
            [
                "Eres un escritor y creador de cuentos supremamente creativo. Con poca informacion puedes crear historias con personajes dados de manera increible. Dame la descripcion en un texto continuo."
            ]
        else
            [
                "Eres un escritor y creador de cuentos supremamente creativo. Dame la descripcion en un texto continuo."
            ]
        end
    end
  
    def test_response
        response = 
        {
            "id" => "3",
            "object" => "chat.completion",
            "created" => 1677763995,
            "model" => "gpt-3.5-turbo",
            "choices" => 
            [
                {
                    "index" => 0,
                    "message" => 
                    {
                        "role" => "assistant",
                        "content" => "El personaje que has creado se llama Eldric. Nacido el 1 de enero de 1390, en un mundo medieval fantástico lleno de magia y criaturas míticas. Eldric es alto y atlético, con cabello largo y plateado, ojos violetas brillantes y una cicatriz en forma de luna creciente en su mejilla izquierda. Viste una túnica azul oscura con runas doradas, botas de cuero reforzadas y un cinturón con bolsillos para pociones y amuletos. Es valiente, curioso y sarcástico, con un fuerte sentido de justicia. Nació en una aldea destruida por un dragón y se convirtió en cazador de dragones para vengar a su familia. Viaja por el reino buscando aventuras y justicia. Tiene la habilidad de manipular el fuego y comunicarse con animales, y es un excelente espadachín. Disfruta leer sobre magia antigua y entrenar con su espada mágica. Le teme a la oscuridad total debido a un trauma de la infancia. Su objetivo es vengar a su familia y restaurar la paz en el reino, soñando con crear una academia para enseñar defensa contra criaturas mágicas. Tiene una lechuza mágica llamada Astra como compañera y su mejor amigo es un mago exiliado llamado Thalanor. Su enemigo principal es un nigromante poderoso llamado Zorath, que quiere dominar el mundo con su ejército de muertos vivientes. Cuenta con el apoyo de un caballero del reino, Sir Gareth, y lleva un amuleto heredado de su madre que lo protege contra la magia oscura."
                    },
                    "finish_reason" => "stop"
                }
            ],
            "usage" => 
            {
                "prompt_tokens" => 56,
                "completion_tokens" => 319,
                "total_tokens" => 375
            }
        }

        response.dig("choices", 0, "message", "content")
    end

    def ask_response(messages)
        puts "Messages being sent: #{messages.inspect}"
        
        response = client.chat(
            parameters: {
                model: "gpt-3.5-turbo",
                messages: messages,
                temperature: 0.7
            }
        )
    
        puts response.dig("choices", 0, "message", "content")
        response.dig("choices", 0, "message", "content")
    end
end
  