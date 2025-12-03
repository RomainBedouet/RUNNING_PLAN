class ChatController < ApplicationController

  def create
    @chat = @chat.new
    @chat.save
  end


end
