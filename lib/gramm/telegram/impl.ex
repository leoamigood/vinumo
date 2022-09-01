defmodule Telegram.Impl do
  @moduledoc false
  @behaviour Telegram

  defdelegate request(token, method, parameters), to: Telegram.Api
end
