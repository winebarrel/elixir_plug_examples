defmodule ElixirPlugExamples.KeyGeneratorPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    # see https://hexdocs.pm/plug/Plug.Crypto.KeyGenerator.html
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Plug.Crypto.KeyGenerator.generate("secret", "salt"))
  end
end

#mix run --no-halt -e ElixirPlugExamples.KeyGeneratorPlug.start
