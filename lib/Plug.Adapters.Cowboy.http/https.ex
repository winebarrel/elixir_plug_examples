defmodule ElixirPlugExamples.HttpsPlug do
  import Plug.Conn

  def start do
    cowboy_options = [
      keyfile: Path.join([__DIR__, "server.key"]),
      certfile: Path.join([__DIR__, "server.crt"]),
      port: 9001
    ]

    {:ok, _pid} = Plug.Adapters.Cowboy.https __MODULE__, [], cowboy_options
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

#mix run --no-halt -e ElixirPlugExamples.HttpsPlug.start
