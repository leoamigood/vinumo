Hammox.defmock(Gramm.Bot.FreshaMock, for: Gramm.Bot)

defmodule Mock do
  @moduledoc false

  def allow_to_call_impl(module, method, arity) do
    impl = Function.capture(Module.concat(module, Impl), method, arity)
    Hammox.expect(module.impl(), method, impl)
  end
end
