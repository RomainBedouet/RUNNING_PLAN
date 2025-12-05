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

    history = user.chat_messages.order(:created_at).map { |msg| { role: msg.role, content: msg.content } }

    if history.empty?
      history << {
        role: "system",
        content: "#{profile} #{goals_text}
        Tu es un coach sportif spécialisé en running..."
      }
    end

    history << { role: "user", content: question }

    # ---- APPEL API OPENAI ----
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: history
      }
    )

    answer = response.dig("choices", 0, "message", "content")

    # ---- Mise à jour des objectifs ----
    if answer.include?("[UPDATE_GOALS]")
      raw = answer.split("[UPDATE_GOALS]").last.strip
      new_goals = raw.split(",").map(&:strip)
      user.objectifs = Objectif.where(name: new_goals)
      answer = answer.gsub(/\[UPDATE_GOALS\].*/, "").strip
    end

    user.chat_messages.create(role: "user", content: question)
    user.chat_messages.create(role: "assistant", content: answer)

    @answer = answer
    render :show
  end
end
