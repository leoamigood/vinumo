defmodule Gramm.Bot.Command.Location do
  @moduledoc false

  use Gramm.Bot.Messaging

  def request_location(%{message: %{text: "/location", chat: %{id: chat_id}}}, token) do
    reply("Let's find nearby service...")
    |> with_reply_keyboard(with_buttons())
    |> reply_keyboard_options(%{one_time_keyboard: true})
    |> send_message(chat_id, token)
  end

  def send(%{message: %{chat: %{id: chat_id}, location: location}}, token) do
    reply("Your location: #{location.latitude}, #{location.longitude}")
    |> send_message(chat_id, token)
  end

  defp with_buttons do
    [[%{text: "Send my location!", request_location: true}], ["Cancel"]]
  end
end
