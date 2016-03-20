defmodule ElixirPlugExamples.Builder do
  use Plug.Builder

  plug :hello
  plug :world
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  # Override
  def init(opts) do
    IO.inspect opts
  end

  def hello(conn, _opts) do
    conn |> assign(:msg, "hello")

    # stop response
    #conn |>send_resp(200, "stopped") |> halt
  end

  def world(conn, _opts) do
    msg = conn.assigns[:msg] <> " world"
    conn |> assign(:msg, msg)
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, conn.assigns[:msg])
  end
end

#mix run --no-halt -e ElixirPlugExamples.Builder.start
