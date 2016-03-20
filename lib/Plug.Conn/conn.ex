defmodule ElixirPlugExamples.ConnPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    IO.inspect conn

    # => %Plug.Conn{
    #      adapter: {Plug.Adapters.Cowboy.Conn, :...},
    #      assigns: %{},
    #      before_send: [],
    #      body_params: %Plug.Conn.Unfetched{aspect: :body_params},
    #      cookies: %Plug.Conn.Unfetched{aspect: :cookies},
    #      halted: false,
    #      host: "localhost",
    #      method: "GET",
    #      owner: #PID<0.248.0>,
    #      params: %Plug.Conn.Unfetched{aspect: :params},
    #      path_info: [],
    #      peer: {{127, 0, 0, 1}, 56143},
    #      port: 9001,
    #      private: %{},
    #      query_params: %Plug.Conn.Unfetched{aspect: :query_params},
    #      query_string: "",
    #      remote_ip: {127, 0, 0, 1},
    #      req_cookies: %Plug.Conn.Unfetched{aspect: :cookies},
    #      req_headers: [
    #        {"host", "localhost:9001"},
    #        {"user-agent", "curl/7.43.0"},
    #        {"accept", "*/*"}],
    #      request_path: "/",
    #      resp_body: nil,
    #      resp_cookies: %{},
    #      resp_headers: [
    #        {"cache-control","max-age=0, private, must-revalidate"}],
    #      scheme: :http,
    #      script_name: [],
    #      secret_key_base: nil,
    #      state: :unset,
    #      status: nil}

    # see https://hexdocs.pm/plug/Plug.Conn.html

    # Get the information of the connection:
    # get_xxx(conn, ...)

    # Add the information to the connection:
    # put_xxx(conn, ...)

    conn = async_assign(conn, :hello, fn -> :world end)
    conn = await_assign(conn, :hello)

    # fetch user data
    IO.inspect conn.assigns[:hello]
    # => :world

    conn
    |> put_resp_content_type("text/plain")
    |> put_resp_header("foo", "bar")
    |> send_resp(200, "Hello world")
  end
end

#mix run --no-halt -e ElixirPlugExamples.ConnPlug.start
