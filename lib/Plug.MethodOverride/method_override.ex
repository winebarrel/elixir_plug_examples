defmodule ElixirPlugExamples.MethodOverridePlug do
  use Plug.Builder

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.MethodOverride
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(%Plug.Conn{method: "GET"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "GET")
  end

  def resp(%Plug.Conn{method: "POST"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "POST")
  end

  def resp(%Plug.Conn{method: "PUT"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "PUT")
  end

  def resp(%Plug.Conn{method: "PATCH"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "PATCH")
  end

  def resp(%Plug.Conn{method: "DELETE"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "DELETE")
  end
end

#mix run --no-halt -e ElixirPlugExamples.MethodOverridePlug.start
#curl -d _method=PUT http://localhost:9001
#curl -d _method=PATCH http://localhost:9001
#curl -d _method=PUT http://localhost:9001
