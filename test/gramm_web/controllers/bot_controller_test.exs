defmodule GrammBot.BotControllerTest do
  use GrammWeb.ConnCase

  @json_api_media_type "application/vnd.api+json"

  test "POST /bot/:url_token", %{conn: conn} do
    token = Application.fetch_env!(:gramm, :token_bot)
    payload = Jason.encode!(valid_payload())

    conn
    |> put_api_content_type_header
    |> post(Routes.bot_path(conn, :create, token), payload)
    |> response(200)
  end

  test "POST /bot/:invalid_url_token", %{conn: conn} do
    payload = Jason.encode!(valid_payload())

    conn
    |> put_api_content_type_header
    |> post(Routes.bot_path(conn, :create, "invalid_token"), payload)
    |> response(404)
  end

  defp valid_payload do
    %{
      "message" => %{
        "chat" => %{
          "first_name" => "Leo",
          "id" => 304_103_618,
          "type" => "private",
          "username" => "NYCTrooper"
        },
        "date" => 1_661_697_354,
        "entities" => [%{"length" => 6, "offset" => 0, "type" => "bot_command"}],
        "from" => %{
          "first_name" => "Leo",
          "id" => 304_103_618,
          "is_bot" => false,
          "language_code" => "en",
          "username" => "NYCTrooper"
        },
        "message_id" => 1,
        "text" => "/start"
      },
      "update_id" => 324_623_825
    }
  end

  def put_api_content_type_header(conn) do
    Plug.Conn.put_req_header(conn, "content-type", @json_api_media_type)
  end
end
