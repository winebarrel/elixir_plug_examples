defmodule ElixirPlugExamples.StaticPlug do
  use Plug.Builder

  plug Plug.Static, at: "/public", from: __DIR__
  plug :not_found

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end

#mix run --no-halt -e ElixirPlugExamples.StaticPlug.start
#open http://localhost:9001/public/logo.png
