defmodule ElixirPlugExamples.RouterPlug do
  use Plug.Router

  plug :match
  plug :dispatch

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/hello/r*glob" do
    send_resp(conn, 200, "route after /hello: #{inspect glob}")
  end

  get "/hello/:name" do
    send_resp(conn, 200, "hello #{name}")
  end

  match "/foo/:bar" when byte_size(bar) <= 2, via: :get do
    send_resp(conn, 200, "hello world #{inspect(bar)}")
  end

  match "/foo/bar", via: :get do
    send_resp(conn, 200, "hello world")
  end

  #match ["foo", bar], via: :get do
  #  send_resp(conn, 200, "hello world")
  #end

  # FIXME; Not work! why?
  #defp match("GET", ["foo", "bar"], conn) do
  #  send_resp(conn, 200, "hello world")
  #end

  match _ do
    send_resp(conn, 404, "oops")
  end
end

#mix run --no-halt -e ElixirPlugExamples.RouterPlug.start
