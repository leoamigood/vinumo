defmodule Gramm.Bot.Command.Curator do
  @moduledoc false

  require Logger

  use Gramm.Bot.Messaging

  alias Gramm.Ostendo

  def shows(%{message: %{text: "/shows", chat: %{id: chat_id}}}, token) do
    case Ostendo.impl().shows do
      {:ok, %{status: 200, body: body}} ->
        reply("Available shows:")
        |> with_inline_keyboard(with_buttons("show", body))
        |> send_message(chat_id, token)

      response ->
        reply("Service currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  def episodes(%{callback_query: %{data: "show:" <> uuid, from: %{id: chat_id}}}, token) do
    case Ostendo.impl().show(uuid) do
      {:ok, %{status: 200, body: body}} ->
        reply("Available episodes:")
        |> with_inline_keyboard(with_buttons("episode", body[:episodes]))
        |> send_message(chat_id, token)

      {:ok, %{status: 404}} ->
        reply("No episodes yet!") |> send_message(chat_id, token)

      response ->
        reply("Service currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  defp with_buttons(type, items) do
    Enum.map(items, &[%{text: &1.name, callback_data: "#{type}:#{&1.identifier}"}])
  end
end
