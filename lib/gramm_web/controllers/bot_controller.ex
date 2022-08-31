defmodule GrammBot.BotController do
  use GrammWeb, :controller

  alias Gramm.Bot.Fresha

  def create(conn, %{"url_token" => token} = update) do
    case Application.fetch_env!(:gramm, :token_bot) do
      ^token ->
        Fresha.dispatch_update(update, token)
        send_resp(conn, 200, "")

      _ ->
        send_resp(conn, 404, "")
    end
  end
end
