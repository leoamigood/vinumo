defmodule GrammWeb.PageController do
  use GrammWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
