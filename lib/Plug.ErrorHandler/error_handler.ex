defmodule ElixirPlugExamples.ErrorHandlerPlug do
  import Plug.Conn
  use Plug.ErrorHandler

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(_conn, _opts) do
    raise "oops"
  end

  defp handle_errors(conn, err) do
    send_resp(conn, conn.status, inspect(err))
    #=> %{kind: :error, reason: %RuntimeError{message: "oops"}, stack: [{ElixirPlugExamples.ErrorHandlerPlug, :"call (overridable 1)", 2, [file: 'lib/Plug.ErrorHandler/error_handler.ex', line: 14]}, {ElixirPlugExamples.ErrorHandlerPlug, :call, 2, [file: 'lib/plug/error_handler.ex', line: 63]}, {Plug.Adapters.Cowboy.Handler, :upgrade, 4, [file: 'lib/plug/adapters/cowboy/handler.ex', line: 15]}, {:cowboy_protocol, :execute, 4, [file: 'src/cowboy_protocol.erl', line: 442]}]}
  end
end

#mix run --no-halt -e ElixirPlugExamples.ErrorHandlerPlug.start
