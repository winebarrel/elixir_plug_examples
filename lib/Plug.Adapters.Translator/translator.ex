defmodule ElixirPlugExamples.TranslatorPlug do
  import Plug.Conn
  require Logger

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    # Convert error message to "19:20:28.194 [error] Ranch listener XXX ref protocol pid reason"
    # see https://github.com/elixir-lang/plug/blob/v1.1.2/lib/plug/adapters/translator.ex#L14
    Logger.error ['Ranch listener XXX', [" ref", " protocol", " pid", " reason"]]

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

#mix run --no-halt -e ElixirPlugExamples.TranslatorPlug.start
