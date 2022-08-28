defmodule GrammBot.BotController do
  use GrammWeb, :controller

  alias Gramm.Bot.Counter

  def create(conn, update = %{"url_token" => token}) do
    case Application.fetch_env!(:gramm, :token_bot) do
      ^token ->
        Counter.dispatch_update(update, token)
        send_resp(conn, 200, "")

      _ ->
        send_resp(conn, 404, "")
    end
  end
end
