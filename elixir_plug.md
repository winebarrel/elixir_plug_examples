# Plugのモジュールを
# 一通り使ってみた
## Genki Sugawara
### Elixir Meetup #2 in Drecom

---
# 自己紹介

* twitter: @sgwr_dts
* github/bitbicket: winebarrel
* 恵比寿の会社でインフラエンジニアをやってます
* 普段はRubyとかAWSとか使ってます

---
# 本日のサンプルコード

## https://github.com/winebarrel/elixir\_plug\_examples

```sh
git clone ...
cd elixir_plug_examples
mix deps.get
mix run --no-halt -e ElixirPlugExamples.HttpPlug.start
```

---
# Plugとは

**https://hexdocs.pm/plug/**

> Plug is:
> A specification for composable modules between web applications
> Connection adapters for different web servers in the Erlang VM

---
# Plugとは

* Python: WSGI
* Ruby: Rack
* Perl: PSGI/Plack
* Node.js: ExpressのMiddleware

---
# Plugのモジュール
Plug.Adapters.Cowboy
Plug.Adapters.Translator
Plug.Builder
Plug.CSRFProtection
Plug.Conn
Plug.Conn.Adapter
Plug.Conn.Cookies
Plug.Conn.Query
Plug.Conn.Status
Plug.Conn.Unfetched
Plug.Conn.Utils

---
# Plugのモジュール
Plug.Crypto
Plug.Crypto.KeyGenerator
Plug.Crypto.MessageEncryptor
Plug.Crypto.MessageVerifier
Plug.Debugger
Plug.ErrorHandler
Plug.HTML
Plug.Head
Plug.Logger
Plug.MIME
Plug.MethodOverride

---
# Plugのモジュール
Plug.Parsers
Plug.Parsers.JSON
Plug.Parsers.MULTIPART
Plug.Parsers.URLENCODED
Plug.RequestId
Plug.Router
Plug.SSL
Plug.Session
Plug.Session.COOKIE
Plug.Session.ETS
Plug.Session.Store

---
# Plugのモジュール
Plug.Static
Plug.Test
Plug.Upload

---
# Plug.Adapters.Cowboy

* Cowboyのアダプタ
* いまのところこれだけ

---
# Plug.Adapters.Cowboy

```elixir
defmodule ElixirPlugExamples.HttpPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

Plug.Adapters.Cowboy.http ElixirPlugExamples.HttpPlug, [], port: 9001
```

---
# Plug.Adapters.Cowboy

```elixir
defmodule ElixirPlugExamples.HttpsPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

Plug.Adapters.Cowboy.https ElixirPlugExamples.HttpsPlug, [], [
  keyfile: Path.join([__DIR__, "server.key"]),
  certfile: Path.join([__DIR__, "server.crt"]),
  port: 9001]
```

---
# Plug.Adapters.Translator
* Plugの特定のエラーメッセージのフォーマットを変更
* ライブラリ内で利用

```elixir
Logger.error ['Ranch listener XXX',
  [" ref", " protocol", " pid", " reason"]]
```

---
# Plug.Builder

* plugというマクロを追加
  * Rackでいうところの`use`を定義
* 内部でPlug.Connをインポート
* モジュール外の関数も呼び出せる

```elixir
import AnotherModule, only: [interesting_plug: 2]
plug :interesting_plug
```

---
# Plug.Builder

```elixir
defmodule ElixirPlugExamples.BuilderPlug do
  use Plug.Builder

  plug :hello
  plug :world
  plug :append, "Zzz"
  plug :resp

  def hello(conn, _opts) do
    conn |> assign(:msg, "hello")

    # stop response
    #conn |>send_resp(200, "stopped") |> halt
  end
  #(続く)
```

---
# Plug.Builder

```elixir
  #(続き)
  def world(conn, _opts) do
    msg = conn.assigns[:msg] <> " world"
    conn |> assign(:msg, msg)
  end

  def append(conn, opts) do
    msg = conn.assigns[:msg] <> opts
    conn |> assign(:msg, msg)
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, conn.assigns[:msg])
  end
end
```

---
# Plug.CSRFProtection

* CSRF対策のトークン生成とチェック

---
# Plug.CSRFProtection

```elixir
defmodule ElixirPlugExamples.CSRFProtectionPlug do
  use Plug.Builder

  plug Plug.Session, store: :ets, key: "_my_app_session", table: :session
  plug :fetch_session
  plug Plug.CSRFProtection
  plug :resp

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Plug.CSRFProtection.get_csrf_token)
  end
end
```
```elixir
:ets.new(:session, [:named_table, :public, read_concurrency: true])
```

---
# Plug.Conn

* コネクションまわりの基本的な機能のモジュール
* リクエストから取得: `get_xxx(conn, ...)`
* レスポンスに追加: `put_xxx(conn, ...)`
* その他セッション操作したり、ユーザデータを操作したり…

```elixir
def call(conn, _opts) do
  ...
end
```

---
# Plug.Conn

```elixir
%Plug.Conn{
  adapter: {Plug.Adapters.Cowboy.Conn, :...},
  assigns: %{},
  before_send: [],
  body_params: %Plug.Conn.Unfetched{aspect: :body_params},
  cookies: %Plug.Conn.Unfetched{aspect: :cookies},
  halted: false,
  host: "localhost",
  method: "GET",
  owner: #PID<0.248.0>,
  params: %Plug.Conn.Unfetched{aspect: :params},
  path_info: [],
  peer: {{127, 0, 0, 1}, 56143},
  port: 9001,
  private: %{},
  query_params: %Plug.Conn.Unfetched{aspect: :query_params},
  query_string: "",
  #(続く)
```
---
# Plug.Conn

```elixir
  #(続き)
  remote_ip: {127, 0, 0, 1},
  req_cookies: %Plug.Conn.Unfetched{aspect: :cookies},
  req_headers: [
    {"host", "localhost:9001"},
    {"user-agent", "curl/7.43.0"},
    {"accept", "*/*"}],
  request_path: "/",
  resp_body: nil,
  resp_cookies: %{},
  resp_headers: [
    {"cache-control","max-age=0, private, must-revalidate"}],
  scheme: :http,
  script_name: [],
  secret_key_base: nil,
  state: :unset,
  status: nil}
```

---
# Plug.Conn / misc

* Adapter: アダプタのビヘイビア
* Cookies:クッキー便利関数
* Query: クエリーストリング便利関数
* Conn.Status: ステータスコード便利関数
* Unfetched:パラメータやボディーがないときにマップされる値
* Utils: コネクション関連ユーティリティ

---
# Plug.Crypto
* 暗号化やハッシュキーの生成・比較などで使われる内部ライブラリ
* KeyGenerator: パスワードのハッシュ生成など
* MessageEncryptor: メッセージの暗号化など
* MessageVerifier: メッセージへの署名・検査など

---
# Plug.Debugger

* `not a plug`とのこと
* エラーが発生したときにデバッグ画面を表示する

![inline](https://cdn.pbrd.co/images/2pyW0Z1V.png)

---
# Plug.Debugger

```elixir
defmodule ElixirPlugExamples.DebuggerPlug do
  import Plug.Conn
  use Plug.Debugger

  def init(opts), do: opts

  def call(conn, _opts) do
    raise "oops"
  end
end
```

---
# Plug.ErrorHandler

* 文字通りエラーハンドリングするplug

---
# Plug.ErrorHandler

```elixir
defmodule ElixirPlugExamples.ErrorHandlerPlug do
  import Plug.Conn
  use Plug.ErrorHandler

  def init(opts), do: opts

  def call(_conn, _opts) do
    raise "oops"
  end

  defp handle_errors(conn, err) do
    send_resp(conn, conn.status, inspect(err))
  end
end
```

---
# Plug.HTML

* HTMLのエスケープの関数だけ定義

```elixir
Plug.HTML.html_escape("<foo>")
```

---
# Plug.Head

* HEADをGETに変換
* 用途がよくわからない…

---
# Plug.Head

```elixir
defmodule ElixirPlugExamples.HeadPlug do
  use Plug.Builder
  plug Plug.Head
  plug :resp

  def resp(conn, _opts) do
    IO.inspect conn.method #=> GET

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "")
  end
end
```
```sh
curl -XHEAD http://localhost:9001
```

---
# Plug.Logger

* アクセスログを出力

```elixir
plug Plug.Logger, log: :debug
```
```
22:32:24.232 [debug] GET /
22:32:24.232 [debug] Sent 200 in 12µs
```

---
# Plug.MIME

* MIMEの追加
* MIME関連の便利関数

```elixir
config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}
```

---
# Plug.MIME

```elixir
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
```

---
# Plug.MethodOverride
* `_method=PUT`みたいなパラメータをつけてメソッドを変える
* RailsのresourcesのDELETEとかで使われるやつ

---
# Plug.MethodOverride

```elixir
defmodule ElixirPlugExamples.MethodOverridePlug do
  use Plug.Builder

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug Plug.MethodOverride
  plug :resp

  def resp(%Plug.Conn{method: "PUT"} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "PUT")
  end
end
```
```sh
curl -d _method=PUT http://localhost:9001
```

---
# Plug.Parsers

* リクエストボディのパーサ
* 以下に対応
  * JSON
  * MULTIPART
  * URLENCODED

---
# Plug.Parsers

```elixir
defmodule ElixirPlugExamples.ParsersPlug do
  use Plug.Builder

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    json_decoder: Poison # required
  plug :resp

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, inspect(conn.body_params))
  end
end
```
```sh
curl -H "Content-type: application/json" -X POST \
  -d '{"user":{"first_name":"firstname"}}' localhost:9001
```

---
# Plug.RequestId

* リクエストIDをつける

---
# Plug.RequestId

```elixir
defmodule ElixirPlugExamples.RequestIdPlug do
  use Plug.Builder

  plug Plug.RequestId
  plug :resp

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, get_resp_header(conn, "x-request-id"))
    #=> "emv6tkni35sbvl38udbc4qvfhalgvfpj"
  end
end
```

---
# Plug.Router

* ルーティングのDSLを定義できるようにする
* globの動作が奇妙な感じ

---
# Plug.Router

```elixir
defmodule ElixirPlugExamples.RouterPlug do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/hello/r*glob" do
    send_resp(conn, 200, "route after /hello: #{inspect glob}")
  end

  get "/hello/:name" do
    send_resp(conn, 200, "hello #{name}")
  end
  #(続く)
```

---
# Plug.Router

```elixir
  #(続き)
  match "/foo/:bar" when byte_size(bar) <= 2, via: :get do
    send_resp(conn, 200, "hello world #{inspect(bar)}")
  end

  match "/foo/bar", via: :get do
    send_resp(conn, 200, "hello world")
  end

  #match ["foo", bar], via: :get do
  #  send_resp(conn, 200, "hello world")
  #end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
```

---
# Plug.SSL

* httpsへのリダイレクトなどの動作を行う
* `:rewrite_on`、`:hsts`、`:expires`、`:subdomains`、`:host`

```elixir
plug Plug.SSL, rewrite_on: [:x_forwarded_proto]
```

---
# Plug.Session

* セッション機能を提供
* etsとcookieに対応
* cookieもets使ってるっぽい感じ
* memcachedもあった
  * gutschilla/plug-session-memcached

---
# Plug.Session

```elixir
defmodule ElixirPlugExamples.SessionPlug do
  use Plug.Builder

  plug Plug.Session, store: :ets, key: "_my_app_session", table: :session
  plug :fetch_session # required
  plug :resp

  def resp(conn, _opts) do
    count = get_session(conn, :counter) || 0

    conn |> put_session(:counter, count + 1)
    |> put_resp_content_type("text/plain") |> send_resp(200, Integer.to_string(count))
  end
end

:ets.new(:session, [:named_table, :public, read_concurrency: true])
```

---
# Plug.Static

* 静的ファイルの配信機能を提供

---
# Plug.Static

```elixir
defmodule ElixirPlugExamples.StaticPlug do
  use Plug.Builder

  plug Plug.Static, at: "/public", from: __DIR__
  plug :not_found

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
```
---
# Plug.Test

* テストのための便利マクロを定義

---
# Plug.Test

```elixir
defmodule ElixirPlugExamplesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ElixirPlugExamples.HttpPlug

  test "puts session cookie" do
    conn = conn(:get, "/")
    conn = ElixirPlugExamples.HttpPlug.call(conn, [])
    assert conn.resp_body == "xHello world"
  end
end
```

---
# Plug.Upload

* アップロードしたファイルの処理
* 別プロセスで動く

---
# Plug.Upload

```elixir
defmodule ElixirPlugExamples.UploadPlug do
  use Plug.Builder

  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :resp

  def resp(conn, _opts) do
    case conn.params do
      %{"file" => file} -> IO.inspect file
      _ -> IO.puts "'file' key not found"
    end

    conn |> put_resp_content_type("text/plain") |> send_resp(200, "OK")
  end
end

Plug.Upload.start_link
```

---
# Plugの自作

```elixir
defmodule JSONHeaderPlug do
  @behaviour Plug
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn |> put_resp_content_type("application/json")
  end
end
```

---
## 以上です
## ご静聴ありがとうございました

