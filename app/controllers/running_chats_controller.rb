class RunningChatsController < ApplicationController
  before_action :authenticate_user!

  def show
  @answer = nil
  end

  def create
  user = current_user
  question = params[:question]


  # Profil utilisateur
  profile = "Profil du coureur : âge #{user.age}, poids #{user.weight}kg, taille #{user.height}cm, niveau : #{user.level_running}."
  # Objectifs de l'utilisateur
  selected_goals = user.objectifs.map(&:name)
  goals_text = selected_goals.any? ? "Objectifs sélectionnés : #{selected_goals.join(', ')}." : "Aucun objectif défini."

  # Historique des messages
  history = user.chat_messages.order(:created_at).map do |msg|
    { role: msg.role, content: msg.content }
  end

  if history.empty?
    history << {
      role: "system",
      content: "#{profile} #{goals_text}
      Tu es un coach sportif et professionnel de la course à pieds. Tu ne réponds qu'aux questions concernant la course à pied, le running, l'alimentation pour sportifs et les bonnes pratiques du sport en général.
      Tu dois aider le coureur à atteindre ses objectifs, proposer des ajustements si nécessaire et expliquer comment progresser.
      Si la question ne concerne ni la course à pieds, ni le running, ni l'alimentation sportive, réponds seulement : 'Je ne répond qu'aux questions concernant le running.'
      Pour modifier les objectifs du coureur, utilise ce format : [UPDATE_GOALS] objectif1, objectif2, objectif3"
    }
  end

  history << { role: "user", content: question }

  # Création du client RubyLLM et appel au chat
  client = RubyLLM.chat(model: "gpt-4o-mini")
  response = client.ask(history)
  answer = response.content

  # Mise à jour des objectifs si nécessaire
  if answer.include?("[UPDATE_GOALS]")
    raw_goals = answer.split("[UPDATE_GOALS]").last.strip
    new_goals = raw_goals.split(',').map(&:strip)
    user.objectifs = Objectif.where(name: new_goals)
    user.save
    answer = answer.gsub(/\[UPDATE_GOALS\].*/, "").strip
  end

  # Sauvegarde de l'historique des messages
  user.chat_messages.create(role: "user", content: question)
  user.chat_messages.create(role: "assistant", content: answer)

  @answer = answer
  render :show

  end
end
