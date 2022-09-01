defmodule Telegram do
  @moduledoc false

  @implementation Application.compile_env!(:telegram, :api)
  def impl, do: @implementation

  @type parameters :: Keyword.t()
  @type request_result :: {:ok, term()} | {:error, term()}

  @callback request(Telegram.Types.token(), Telegram.Types.method(), parameters()) ::
              request_result()
end
