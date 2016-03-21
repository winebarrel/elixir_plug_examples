defmodule JSONHeaderPlug do
  @behaviour Plug
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn |> put_resp_content_type("application/json")
  end
end

defmodule ElixirPlugExamples.CustomPlug do
  use Plug.Builder

  plug JSONHeaderPlug
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    send_resp(conn, 200, ~s({"foo":"bar"}))
  end
end

#mix run --no-halt -e ElixirPlugExamples.CustomPlug.start
