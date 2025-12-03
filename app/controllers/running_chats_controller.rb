class RunningChatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :create]

  def show
  end

  def create
    question = params[:question]

    chat = RubyLLM.chat
    response = chat.ask("Tu es un expert en running. Réponds uniquement à des questions sur la course à pied. Question: #{question}")

    @answer = response.content
    render :show
  end
end
