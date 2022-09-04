defmodule Gramm.Bot.Fresha do
  use Telegram.Bot
  @moduledoc false

  require Logger

  @command_shows "/shows"
  @command_location "/location"

  alias Gramm.Bot.Command

  @impl Telegram.Bot
  @spec handle_update(map :: map, token :: String.t()) :: {:ok, term()} | {:error, term()}
  def handle_update(update = %{message: %{text: @command_shows}}, token) do
    Command.Shows.send(update, token)
  end

  def handle_update(update = %{message: %{text: @command_location}}, token) do
    Command.Location.request_location(update, token)
  end

  def handle_update(update = %{message: %{location: _location}}, token) do
    Command.Location.send(update, token)
  end

  def handle_update(update, _token) do
    Logger.info(update)
    :ok
  end
end
