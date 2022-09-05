defmodule Gramm.Ostendo.Impl do
  @moduledoc false
  @behaviour Gramm.Ostendo

  defdelegate shows, to: Gramm.Ostendo.Client
  defdelegate show(identifier), to: Gramm.Ostendo.Client
  defdelegate episode(identifier), to: Gramm.Ostendo.Client
end
