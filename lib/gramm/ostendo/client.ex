defmodule Gramm.Ostendo.Client do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://aktiverum.herokuapp.com"
  plug Tesla.Middleware.JSON, engine: Poison, engine_opts: [keys: :atoms]

  @spec shows :: {:ok, term()} | {:error, term()}
  def shows do
    get("/api/v1/shows", query: [auth_token: Application.fetch_env!(:gramm, :ostendo_api_key)])
  end
end
