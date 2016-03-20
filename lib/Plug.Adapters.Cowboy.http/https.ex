defmodule ElixirPlugExamples.HttpsPlug do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

#Plug.Adapters.Cowboy.https ElixirPlugExamples.HttpsPlug, [], keyfile: Path.join([__DIR__, "server.key"]), certfile: Path.join([__DIR__, "server.crt"]), port: 10080
#:timer.sleep(:infinity)
