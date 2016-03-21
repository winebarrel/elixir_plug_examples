defmodule ElixirPlugExamples.HeadPlug do
  use Plug.Builder
  plug Plug.Head
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    IO.inspect conn.method #=> GET

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end
end

#mix run --no-halt -e ElixirPlugExamples.HeadPlug.start
#curl -XHEAD http://localhost:9001
