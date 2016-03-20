defmodule ElixirPlugExamples.SessionPlug do
  use Plug.Builder

  plug Plug.Session, store: :ets, key: "_my_app_session", table: :session
  plug :fetch_session # required
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
    # required
    :ets.new(:session, [:named_table, :public, read_concurrency: true])
  end

  def resp(conn, _opts) do
    count = get_session(conn, :counter) || 0

    conn
    |> put_session(:counter, count + 1)
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Integer.to_string(count))
  end
end

#mix run --no-halt -e ElixirPlugExamples.SessionPlug.start
# FIXME: ２ずつ増えるんですけど…
