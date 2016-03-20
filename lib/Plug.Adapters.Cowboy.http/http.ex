defmodule ElixirPlugExamples.HttpPlug do
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

#Plug.Adapters.Cowboy.http ElixirPlugExamples.HttpPlug, [], port: 10080
#:timer.sleep(:infinity)
