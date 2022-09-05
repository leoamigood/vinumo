defmodule Gramm.Bot.Messaging do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def reply(text, parse_mode \\ "Markdown") do
        %{text: text, parse_mode: parse_mode}
      end

      def with_reply_keyboard(message, keyboard) do
        Map.merge(message, %{reply_markup: %{keyboard: keyboard}})
      end

      def with_inline_keyboard(message, keyboard) do
        Map.merge(message, %{reply_markup: %{inline_keyboard: keyboard}})
      end

      def reply_keyboard_options(message = %{reply_markup: %{keyboard: _keyboard}}, options) do
        %{message | reply_markup: Map.merge(message.reply_markup, options)}
      end

      defp to_keyword_list(map) do
        Enum.map(map, fn {key, value} -> {key, value} end)
      end

      def send_message(message = %{reply_markup: _reply_markup}, chat_id, token) do
        send_message(message |> to_keyword_list, chat_id, token)
      end

      def send_message(message = %{text: _text}, chat_id, token) do
        send_message(message |> to_keyword_list, chat_id, token)
      end

      def send_message(message, chat_id, token) do
        Telegram.impl().request(token, "sendMessage", [chat_id: chat_id] ++ message)
      end

      def video(caption, video_url) do
        %{caption: caption, video: video_url}
      end

      def send_video(message = %{video: video}, chat_id, token) do
        Telegram.impl().request(
          token,
          "sendVideo",
          [chat_id: chat_id] ++ (message |> to_keyword_list)
        )
      end
    end
  end
end
