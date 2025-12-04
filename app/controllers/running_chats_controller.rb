class RunningChatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create]

  def show
  end

  def create
    user = current_user
    question = params[:question]

    profile = "Profil coureur : âge #{user.age}, poids #{user.weight}kg, taille #{user.height}cm, objectif : #{user.goal}, niveau : #{user.level_running}."

    # Load previous messages
    history = user.chat_messages.order(:created_at).map do |m|
      { role: m.role, content: m.content }
    end

    # Add system message only once (first conversation)
    if history.empty?
      history << {
        role: "system",
        content: "#{profile} Tu es un coach sportif et professionnel de la course à pieds, tu ne réponds qu'aux questions concernant la course à pied, le running, l'alimentation pour sportifs et bonne pratique du sport en général. "\"Si la question ne concerne ni la course à pieds, ni le running, ni l'alimentation sportive, réponds seulement: 'Je ne répond qu'aux questions concernant le running.'"
      }
    end


    history << { role: "user", content: question }

    chat = RubyLLM.chat
    response = chat.ask(history)

    answer = response.content

    user.chat_messages.create(role: "user", content: question)
    user.chat_messages.create(role: "assistant", content: answer)

    @answer = answer
    render :show
  end
end
# CODE A METTRE DANS user_controller.rb
      # class User < ApplicationRecord
      #   has_many :chat_messages, dependent: :destroy
      # end
