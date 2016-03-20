defmodule ElixirPlugExamples.DebuggerPlug do
  import Plug.Conn
  use Plug.Debugger

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    raise "oops"
  end
end

#mix run --no-halt -e ElixirPlugExamples.DebuggerPlug.start
#open http://localhost:9001/
