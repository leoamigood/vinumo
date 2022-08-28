defmodule Gramm.Repo do
  use Ecto.Repo,
    otp_app: :gramm,
    adapter: Ecto.Adapters.Postgres
end
