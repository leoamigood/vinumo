defmodule Gramm.Bot.Fresha do
  use Telegram.Bot

  @moduledoc false

  @impl Telegram.Bot
  @spec handle_update(map :: map, token :: String.t()) :: {:ok, term()} | {:error, term()}
  def handle_update(%{message: %{text: "/location", chat: %{id: chat_id}}}, token) do
    Telegram.Api.request(token, "sendMessage",
      chat_id: chat_id,
      text: "Let's find nearby service...",
      parse_mode: "Markdown",
      reply_markup: %{
        one_time_keyboard: true,
        keyboard: [
          [%{text: "Send my location!", request_location: true}],
          ["Cancel"]
        ]
      }
    )
  end

  def handle_update(%{message: %{chat: %{id: chat_id}, location: location}}, token) do
    Telegram.Api.request(token, "sendMessage",
      chat_id: chat_id,
      text: "Your location: #{location.latitude}, #{location.longitude}"
    )
  end

  def handle_update(_update, _token) do
    :ok
  end
end
