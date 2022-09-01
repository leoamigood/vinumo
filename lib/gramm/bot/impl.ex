defmodule Gramm.Bot.Impl do
  @moduledoc false
  @behaviour Gramm.Bot

  defdelegate dispatch_update(update, token),
    to: Gramm.Bot.Fresha,
    as: :handle_update
end
