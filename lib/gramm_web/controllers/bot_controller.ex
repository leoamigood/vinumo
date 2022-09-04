defmodule GrammBot.BotController do
  use GrammWeb, :controller

  alias Gramm.Bot

  def create(conn, update = %{"url_token" => token}) do
    case Application.fetch_env!(:gramm, :token_bot) do
      ^token ->
        Bot.impl().dispatch_update(update, token)
        send_resp(conn, 200, "")

      _ ->
        send_resp(conn, 404, "")
    end
  end
end
