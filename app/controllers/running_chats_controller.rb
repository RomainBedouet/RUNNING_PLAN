class RunningChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @answer = nil
  end

  def create
    user = current_user
    question = params[:question]

    profile = "Profil du coureur : âge #{user.age}, poids #{user.weight}kg, taille #{user.height}cm, niveau : #{user.level_running}."
    selected_goals = user.objectifs.map(&:name)
    goals_text = selected_goals.any? ? "Objectifs sélectionnés : #{selected_goals.join(', ')}." : "Aucun objectif défini."

    history = user.chat_messages.order(:created_at).map do |msg|
      { role: msg.role, content: msg.content }
    end
    if history.empty?
      history << {
        role: "system",
        content: <<~PROMPT
          Tu es un coach professionnel spécialisé UNIQUEMENT dans :
          - la course à pied
          - le running
          - les conseils d'entraînement
          - la nutrition sportive
          - la progression en sport d’endurance

          🚫 Tu NE DOIS JAMAIS répondre à :
          - cuisine
          - santé générale hors sport
          - blagues, discussions personnelles
          - informatique
          - sujets sans rapport avec le sport ou le running
          - toute demande qui ne concerne PAS la course à pied

          SI la question ne concerne PAS la course à pied ou la nutrition sportive :
          👉 Répond STRICTEMENT : "Je ne réponds qu'aux questions concernant le running."
          (NE FOURNIS AUCUNE AUTRE INFORMATION)

          Garde toujours un ton professionnel et orienté coaching sportif.
        PROMPT
      }
    end


    history << { role: "user", content: question }

    # ---- APPEL OPENAI ----
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

   response = client.chat(
  parameters: {
    model: "gpt-4o-mini",
    messages: history
      }
    )

    puts "=== OPENAI RAW RESPONSE ==="
    pp response

    @answer = response.dig("choices", 0, "message", "content")
    puts "=== PARSED ANSWER ==="
    pp @answer

    # Sauvegarde
    user.chat_messages.create(role: "user", content: question)
    user.chat_messages.create(role: "assistant", content: @answer)

    render :show
  end
end
