defmodule ElixirPlugExamples.HeadPlug do
  use Plug.Builder
  plug Plug.Head

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def call(conn, opts) do
    super(conn, opts)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end
end

#mix run --no-halt -e ElixirPlugExamples.HeadPlug.start
#curl -XHEAD http://localhost:9001
