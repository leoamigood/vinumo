defmodule Gramm.Bot.Fresha do
  use Telegram.Bot
  @moduledoc false

  alias Gramm.Ostendo

  @command_shows "/shows"
  @command_location "/location"

  @impl Telegram.Bot
  @spec handle_update(map :: map, token :: String.t()) :: {:ok, term()} | {:error, term()}
  def handle_update(%{message: %{text: @command_shows, chat: %{id: chat_id}}}, token) do
    with {:ok, %{status: 200, body: body}} <- Ostendo.impl().shows,
         shows <- AtomUtils.symbolize_keys(body) do
      reply("Available shows:")
      |> with_inline_keyboard(display_shows(shows))
      |> send_message(chat_id, token)
    else
      response ->
        reply("Shows are currently unavailable!") |> send_message(chat_id, token)
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

  defp reply(text, parse_mode \\ "Markdown") do
    %{text: text, parse_mode: parse_mode}
  end

  defp with_reply_keyboard(message, keyboard) do
    Map.merge(message, %{reply_markup: %{keyboard: keyboard}})
  end

  defp with_inline_keyboard(message, keyboard) do
    Map.merge(message, %{reply_markup: %{inline_keyboard: keyboard}})
  end

  defp display_shows(shows) do
    Enum.map(shows, &[%{text: &1.name, callback_data: &1.identifier}])
  end

  defp reply_keyboard_options(message, options) do
    %{message | reply_markup: Map.merge(message.reply_markup, options)}
  end

  defp to_keyword_list(map) do
    Enum.map(map, fn {key, value} -> {key, value} end)
  end

  defp send_message(message = %{reply_markup: _reply_markup}, chat_id, token) do
    send_message(message |> to_keyword_list, chat_id, token)
  end

  defp send_message(message = %{text: _text}, chat_id, token) do
    send_message(message |> to_keyword_list, chat_id, token)
  end

  defp send_message(message, chat_id, token) do
    Telegram.impl().request(token, "sendMessage", [chat_id: chat_id] ++ message)
  end
end
