defmodule Gramm.Bot.Command.Shows do
  @moduledoc false

  require Logger

  use Gramm.Bot.Messaging

  alias Gramm.Ostendo

  def send(%{message: %{text: "/shows", chat: %{id: chat_id}}}, token) do
    case Ostendo.impl().shows do
      {:ok, %{status: 200, body: shows}} ->
        reply("Available shows:")
        |> with_inline_keyboard(with_buttons(shows))
        |> send_message(chat_id, token)

      response ->
        reply("Shows are currently unavailable!") |> send_message(chat_id, token)
        Logger.info(response)
    end
  end

  defp with_buttons(shows) do
    Enum.map(shows, &[%{text: &1.name, callback_data: &1.identifier}])
  end
end
