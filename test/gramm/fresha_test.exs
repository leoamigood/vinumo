defmodule Gramm.Bot.FreshaTest do
  use Gramm.DataCase

  alias Gramm.Bot.Fresha

  describe "handle_update/1" do
    test "handle update with location message" do
      token = Application.fetch_env!(:gramm, :token_bot)

      Fresha.dispatch_update(location_payload(), token)
    end
  end

  defp location_payload do
    %{
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
      update_id: 324_623_871
    }
  end
end
