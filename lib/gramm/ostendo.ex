defmodule Gramm.Ostendo do
  @moduledoc false

  @implementation Application.compile_env!(:gramm, :ostendo)
  def impl, do: @implementation

  @callback shows :: {:ok, term()} | {:error, term()}
end
