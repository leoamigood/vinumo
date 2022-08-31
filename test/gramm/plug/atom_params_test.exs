defmodule Gramm.Plug.AtomParamsTest do
  use GrammWeb.ConnCase

  alias Gramm.Plug.AtomParams

  test "atomize basic body params", %{conn: conn} do
    input = %{"key" => "string", "integer_key" => 1, "boolean" => true, "4" => 3.14159}
    result = AtomParams.call(%{conn | params: input}, drop_string_keys: true).params

    assert result == %{key: "string", integer_key: 1, boolean: true, "4": 3.14159}
  end

  test "atomize nested body params", %{conn: conn} do
    input = %{"latitude" => 54.117762, "longitude" => 12.05574}

    result =
      AtomParams.call(%{conn | params: %{"message" => input}}, drop_string_keys: true).params

    assert result == %{message: %{latitude: 54.117762, longitude: 12.05574}}
  end

  test "atomize deep structured map", %{conn: conn} do
    input = %{
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
        "location" => %{"latitude" => 54.117762, "longitude" => 12.05574},
        "message_id" => 101
      },
      "update_id" => 324_623_871,
      "url_token" => "invalid_token"
    }

    result = AtomParams.call(%{conn | params: input}, drop_string_keys: true).params

    assert result == %{
             message: %{
               chat: %{
                 first_name: "John",
                 id: 304_103_618,
                 type: "private",
                 username: "AgentBond"
               },
               date: 1_661_800_955,
               from: %{
                 first_name: "John",
                 id: 304_103_618,
                 is_bot: false,
                 language_code: "en",
                 username: "AgentBond"
               },
               location: %{latitude: 54.117762, longitude: 12.05574},
               message_id: 101
             },
             update_id: 324_623_871,
             url_token: "invalid_token"
           }
  end
end
