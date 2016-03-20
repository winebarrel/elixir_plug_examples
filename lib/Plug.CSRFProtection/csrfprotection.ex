defmodule ElixirPlugExamples.CSRFProtectionPlug do
  use Plug.Builder

  # FIXME: Not work!
  #plug Plug.Session, store: :ets, key: "_my_app_session", table: "session"
  #plug :fetch_session
  #plug Plug.CSRFProtection

  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Plug.CSRFProtection.get_csrf_token)
  end
end

#mix run --no-halt -e ElixirPlugExamples.CSRFProtectionPlug.start
