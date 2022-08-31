defmodule Gramm.Plug.AtomParams do
  @behaviour Plug

  @moduledoc false

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  def call(%{params: params} = conn, opts) do
    %{conn | params: symbolize_merge(params, opts)}
  end

  @spec symbolize_merge(map :: map, opts :: Keyword.t()) :: map
  def symbolize_merge(map, opts \\ []) when is_map(map) do
    atom_map =
      map
      |> Map.delete(:__struct__)
      |> symbolize_keys

    if Keyword.get(opts, :drop_string_keys, false) do
      atom_map
    else
      Map.merge(map, atom_map)
    end
  end

  defp symbolize_keys(%{__struct__: _module} = struct) do
    struct
  end

  defp symbolize_keys(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {k, v}, m ->
      map_put(m, k, symbolize_keys(v))
    end)
  end

  defp symbolize_keys(list) when is_list(list) do
    Enum.map(list, &symbolize_keys/1)
  end

  defp symbolize_keys(term), do: term

  defp map_put(map, k, v) when is_map(map) do
    if is_binary(k) do
      Map.put(map, String.to_existing_atom(k), v)
    else
      Map.put(map, k, v)
    end
  rescue
    ArgumentError -> Map.put(map, String.to_atom(k), v)
  end
end
