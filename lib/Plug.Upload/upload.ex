defmodule ElixirPlugExamples.UploadPlug do
  use Plug.Builder

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
    {:ok, _upload_pid} = Plug.Upload.start_link
  end

  def resp(conn, _opts) do
    case conn.params do
      %{"file" => file} ->
        IO.inspect file
      _ ->
        IO.puts "'file' key not found"
    end

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "OK")
  end
end

#mix run --no-halt -e ElixirPlugExamples.UploadPlug.start
#curl -F file=@/etc/ntp.conf localhost:9001

