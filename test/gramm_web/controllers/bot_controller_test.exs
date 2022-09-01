defmodule GrammBot.BotControllerTest do
  use GrammWeb.ConnCase

  import Hammox
  setup :verify_on_exit!

  @json_api_media_type "application/vnd.api+json"

  test "POST /bot/:url_token", %{conn: conn} do
    token = Application.fetch_env!(:gramm, :token_bot)
    payload = Jason.encode!(location_request())

#    Mock.allow_to_call_impl(Gramm.Bot, :dispatch_update, 2)

    expect(Gramm.Bot.impl(), :dispatch_update, fn _update, token ->
      assert token == Application.fetch_env!(:gramm, :token_bot)

      {:ok, location_response()}
    end)

    conn
    |> put_api_content_type_header
    |> post(Routes.bot_path(conn, :create, token), payload)
    |> response(200)
  end

  test "POST /bot/:invalid_url_token", %{conn: conn} do
    payload = Jason.encode!(location_request())

    conn
    |> put_api_content_type_header
    |> post(Routes.bot_path(conn, :create, "invalid_token"), payload)
    |> response(404)
  end

  defp location_request do
    %{
      "message" => %{
        "chat" => %{
          "first_name" => "John",
          "id" => 304_103_618,
          "type" => "private",
          "username" => "AgentBond"
        },
        "date" => 1_661_800_955,
        "from" => %{
          "first_name" => "John",
          "id" => 304_103_618,
          "is_bot" => false,
          "language_code" => "en",
          "username" => "AgentBond"
        },
        "location" => %{"latitude" => 55.117762, "longitude" => 13.05574},
        "message_id" => 101
      },
      "update_id" => 324_623_871
    }
  end

  def location_response do
    {:ok,
     %{
       "chat" => %{
         "first_name" => "John",
         "id" => 304_103_618,
         "type" => "private",
         "username" => "AgentBond"
       },
       "date" => 1_661_994_307,
       "from" => %{
         "first_name" => "gramm",
         "id" => 5_755_304_518,
         "is_bot" => true,
         "username" => "bot"
       },
       "message_id" => 152,
       "text" => "Your location: 55.117867, 13.055907"
     }}
  end

  def put_api_content_type_header(conn) do
    Plug.Conn.put_req_header(conn, "content-type", @json_api_media_type)
  end
end
