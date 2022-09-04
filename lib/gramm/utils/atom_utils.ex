defmodule AtomUtils do
  @moduledoc false

  def symbolize_keys(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {k, v}, m ->
      map_put(m, k, symbolize_keys(v))
    end)
  end

  def symbolize_keys(list) when is_list(list) do
    Enum.map(list, &symbolize_keys/1)
  end

  def symbolize_keys(term), do: term

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
