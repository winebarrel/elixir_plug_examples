defmodule ElixirPlugExamples.ParsersPlug do
  use Plug.Builder

  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], json_decoder: Poison
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn.body_params))
  end
end

#mix run --no-halt -e ElixirPlugExamples.ParsersPlug.start
#curl -H "Content-type: application/json" -X POST -d '{"user":{"first_name":"firstname","last_name":"lastname","email":"email@email.com","password":"app123","password_confirmation":"app123"}}' localhost:9001
