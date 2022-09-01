defmodule Gramm.Bot do
  @moduledoc false

  @implementation Application.compile_env!(:gramm, :bot)
  def impl, do: @implementation

  @callback dispatch_update(map, String.t()) :: {:ok, term()} | {:error, term()}
end
