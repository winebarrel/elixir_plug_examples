defmodule ElixirPlugExamples.SSLPlug do
  use Plug.Builder

  plug Plug.SSL, rewrite_on: [:x_forwarded_proto]
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "scheme: #{inspect(conn.scheme)}")
  end
end

#mix run --no-halt -e ElixirPlugExamples.SSLPlug.start
#curl -H "x-forwarded-proto: https" localhost:9001
