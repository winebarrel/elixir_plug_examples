defmodule ElixirPlugExamples.HttpPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
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

#mix run --no-halt -e ElixirPlugExamples.HttpPlug.start
