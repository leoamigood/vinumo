defmodule Gramm.Ostendo do
  @moduledoc false

  @implementation Application.compile_env!(:gramm, :ostendo)
  def impl, do: @implementation

  @type uuid :: String.t()

  @callback shows :: {:ok, term()} | {:error, term()}
  @callback show(uuid) :: {:ok, term()} | {:error, term()}
  @callback episode(uuid) :: {:ok, term()} | {:error, term()}
end
