defmodule ElixirPlugExamples.LoggerPlug do
  use Plug.Builder
  plug Plug.Logger, log: :debug
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "hello")
    #=> 22:32:24.232 [debug] GET /
    #   22:32:24.232 [debug] Sent 200 in 12µs
  end
end

#mix run --no-halt -e ElixirPlugExamples.LoggerPlug.start
