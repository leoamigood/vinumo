defmodule Gramm.Plug.AtomParams do
  @behaviour Plug

  @moduledoc false

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  def call(conn = %{params: params}, opts) do
    %{conn | params: symbolize(params, opts)}
  end

  @spec symbolize(map :: map, opts :: Keyword.t()) :: map
  def symbolize(map, opts \\ []) when is_map(map) do
    atom_map =
      map
      |> Map.delete(:__struct__)
      |> AtomUtils.symbolize_keys()

    if Keyword.get(opts, :drop_string_keys, false) do
      atom_map
    else
      Map.merge(map, atom_map)
    end
  end
end
