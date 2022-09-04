defmodule Gramm.Ostendo.Client do
  @moduledoc false

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://aktiverum.herokuapp.com"
  plug Tesla.Middleware.JSON, engine: Poison, engine_opts: [keys: :atoms]
  plug Tesla.Middleware.PathParams

  @spec shows :: {:ok, term()} | {:error, term()}
  def shows do
    get("/api/v1/shows", query: [auth_token: Application.fetch_env!(:gramm, :ostendo_api_key)])
  end

  @spec show(Gramm.Ostendo.uuid()) :: {:ok, term()} | {:error, term()}
  def show(identifier) do
    params = [identifier: identifier]

    get("/api/v1/shows/:identifier",
      opts: [path_params: params],
      query: [auth_token: Application.fetch_env!(:gramm, :ostendo_api_key)]
    )
  end
end
