defmodule Gramm.Ostendo.Client do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://aktiverum.herokuapp.com"
  plug Tesla.Middleware.JSON

  @spec shows :: {:ok, term()} | {:error, term()}
  def shows do
    get("/api/v1/shows")
  end
end
