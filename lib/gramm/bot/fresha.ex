defmodule Gramm.Bot.Fresha do
  use Telegram.Bot
  @moduledoc false

  alias Gramm.Ostendo

  @command_shows "/shows"
  @command_location "/location"

  @impl Telegram.Bot
  @spec handle_update(map :: map, token :: String.t()) :: {:ok, term()} | {:error, term()}
  def handle_update(%{message: %{text: @command_shows, chat: %{id: chat_id}}}, token) do
    case Ostendo.impl().shows do
      {:ok, %{status: 200, body: payload}} ->
        "Available shows: #{Enum.map_join(payload, ", ", &Map.get(&1, "name"))}"
        |> send_message(chat_id, token)

      response ->
        "Shows are currently unavailable!" |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  def handle_update(%{message: %{text: @command_location, chat: %{id: chat_id}}}, token) do
    Telegram.impl().request(token, "sendMessage",
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
    Telegram.impl().request(token, "sendMessage",
      chat_id: chat_id,
      text: "Your location: #{location.latitude}, #{location.longitude}"
    )
  end

  def handle_update(update, _token) do
    Logger.info(update)
    :ok
  end

  defp send_message(text, chat_id, token) do
    Telegram.impl().request(token, "sendMessage", chat_id: chat_id, text: text)
  end
end
