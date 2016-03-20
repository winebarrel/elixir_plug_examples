defmodule ElixirPlugExamples.RequestIdPlug do
  use Plug.Builder

  plug Plug.RequestId
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, get_resp_header(conn, "x-request-id"))
  end
end

#mix run --no-halt -e ElixirPlugExamples.RequestIdPlug.start
