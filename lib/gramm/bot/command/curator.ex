defmodule Gramm.Bot.Command.Curator do
  @moduledoc false

  require Logger

  use Gramm.Bot.Messaging

  alias Gramm.Ostendo

  def shows(%{message: %{text: "/shows", chat: %{id: chat_id}}}, token) do
    case Ostendo.impl().shows do
      {:ok, %{status: 200, body: body}} ->
        result =
          reply("Available shows:")
          |> with_inline_keyboard(with_buttons("show", body))
          |> send_message(chat_id, token)

        Logger.info("Sent message: #{inspect result}")

      response ->
        reply("Service currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  def show(%{callback_query: %{data: "show:" <> identifier, from: %{id: chat_id}}}, token) do
    case Ostendo.impl().show(identifier) do
      {:ok, %{status: 200, body: body}} ->
        result =
          reply("Show episodes:")
          |> with_inline_keyboard(with_buttons("episode", body[:episodes]))
          |> send_message(chat_id, token)

        Logger.info("Sent message: #{inspect result}")

      {:ok, %{status: 404}} ->
        reply("Not found!") |> send_message(chat_id, token)

      response ->
        reply("Service currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  def episode(%{callback_query: %{data: "episode:" <> identifier, from: %{id: chat_id}}}, token) do
    case Ostendo.impl().episode(identifier) do
      {:ok, %{status: 200, body: body}} ->
        result =
          video(body[:name], body[:video_url])
          |> send_video(chat_id, token)

        Logger.info("Sent video: #{inspect result}")

      {:ok, %{status: 404}} ->
        reply("Not found!") |> send_message(chat_id, token)

      response ->
        reply("Service currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  defp with_buttons(type, items) do
    Enum.map(items, &[%{text: &1.name, callback_data: "#{type}:#{&1.identifier}"}])
  end
end
