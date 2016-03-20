# see https://hexdocs.pm/plug/Plug.MIME.html
#config :plug, :mimes, %{
#  "application/vnd.api+json" => ["json-api"]
#}

defmodule ElixirPlugExamples.MIMEPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    IO.inspect Plug.MIME.extensions("text/html")
    #=> ["html", "htm"]

    IO.inspect Plug.MIME.extensions("application/json")
    #=> ["json"]

    IO.inspect Plug.MIME.extensions("foo/bar")
    #=> []

    IO.inspect Plug.MIME.path("index.html")
    #=> "text/html"

    IO.inspect Plug.MIME.type("txt")
    #=> "text/plain"

    IO.inspect Plug.MIME.type("foobarbaz")
    #=> "application/octet-stream"

    IO.inspect Plug.MIME.valid?("text/plain")
    #=> true

    IO.inspect Plug.MIME.valid?("foo/bar")
    #=> false

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

#mix run --no-halt -e ElixirPlugExamples.MIMEPlug.start
