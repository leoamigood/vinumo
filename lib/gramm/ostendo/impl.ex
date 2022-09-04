defmodule Gramm.Ostendo.Impl do
  @moduledoc false
  @behaviour Gramm.Ostendo

  defdelegate shows, to: Gramm.Ostendo.Client
  defdelegate show(uuid), to: Gramm.Ostendo.Client
end
