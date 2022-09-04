defmodule Gramm.Bot.FreshaTest do
  use Gramm.DataCase

  alias Gramm.Bot.Fresha
  alias Gramm.Ostendo

  import Hammox
  setup :verify_on_exit!

  setup do
    %{token: Application.fetch_env!(:gramm, :token_bot)}
  end

  describe "handle_update/1" do
    test "handle shows display", %{token: token} do
      #      Mock.allow_to_call_impl(Telegram, :request, 3)

      expect(Ostendo.impl(), :shows, fn -> {:ok, %{status: 200, body: shows_response()}} end)
      expect(Telegram.impl(), :request, fn _token, _command, _payload -> {:ok, %{}} end)

      Fresha.handle_update(shows_request(), token)
    end

    test "handle update with location message", %{token: token} do
      expect(Telegram.impl(), :request, fn _token, _command, _payload -> {:ok, %{}} end)

      Fresha.handle_update(location_payload(), token)
    end
  end

  defp location_payload do
    %{
      message: %{
        chat: %{
          first_name: "James",
          id: 304_103_618,
          type: "private",
          username: "AgentBond"
        },
        date: 1_661_800_955,
        from: %{
          first_name: "James",
          id: 304_103_618,
          is_bot: false,
          language_code: "en",
          username: "AgentBond"
        },
        location: %{latitude: 54.117762, longitude: 12.05574},
        message_id: 101
      },
      update_id: 324_623_871
    }
  end

  defp shows_request do
    %{
      :message => %{
        chat: %{first_name: "James", id: 304_103_618, type: "private", username: "AgentBond"},
        date: 1_662_061_434,
        entities: [%{length: 6, offset: 0, type: "bot_command"}],
        from: %{
          first_name: "James",
          id: 304_103_618,
          is_bot: false,
          language_code: "en",
          username: "AgentBond"
        },
        message_id: 162,
        text: "/shows"
      },
      :update_id => 324_623_895
    }
  end

  def shows_response() do
    shows = [
      %{
        name: "High maintenance",
        identifier: "953d9b64-1d9a-4593-ba63-65ae709d5bce",
        episodes: []
      },
      %{
        name: "Two and a half men",
        identifier: "428b87af-376c-4ccd-808d-9672094de0e2",
        episodes: [
          %{
            name: "Pilot",
            identifier: "e8bb1334-30b1-4431-9997-822804bcbc3a",
            video: "https://s3hosting.com/path/to/video"
          }
        ]
      }
    ]
  end
end
