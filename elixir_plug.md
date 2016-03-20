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
# Plugとは

**https://hexdocs.pm/plug/**

> Plug is:
> A specification for composable modules between web applications
> Connection adapters for different web servers in the Erlang VM

アプリケーションサーバのI/Fを標準化するライブラリ
（だと思います）

---
# Plugとは

* Python: WSGI
* Ruby: Rack
* Perl: PSGI/Plack
* Node.js: ExpressのMiddleware

---
# 本日のサンプルコード

## https://github.com/winebarrel/elixir\_plug\_examples

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
### http

```elixir
defmodule ElixirPlugExamples.HttpPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
```

---
# Plug.Adapters.Cowboy
### https

```elixir
defmodule ElixirPlugExamples.HttpsPlug do
  import Plug.Conn

  def start do
    cowboy_options = [
      keyfile: Path.join([__DIR__, "server.key"]),
      certfile: Path.join([__DIR__, "server.crt"]),
      port: 9001
    ]

    {:ok, _pid} = Plug.Adapters.Cowboy.https __MODULE__, [], cowboy_options
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
```

---
# Plug.Adapters.Translator
* Plugの特定のエラーメッセージのフォーマットを変更
  * ライブラリ内で利用
* なぜPlug.Adapters配下にあるのか…

```elixir
Logger.error ['Ranch listener XXX',
  [" ref", " protocol", " pid", " reason"]]
```

---
# Plug.Builder

* plugというマクロを追加
  * Rackの`use`
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

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  # Override Plug.Conn.init()
  def init(opts) do
    IO.inspect opts
  end
  #(続く)
```

---
# Plug.Builder

```elixir
  #(続き)
  def hello(conn, _opts) do
    conn |> assign(:msg, "hello")

    # stop response
    #conn |>send_resp(200, "stopped") |> halt
  end

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

```elixir
defmodule ElixirPlugExamples.CSRFProtectionPlug do
  use Plug.Builder

  plug Plug.Session, store: :ets, key: "_my_app_session", table: :session
  plug :fetch_session
  plug Plug.CSRFProtection
  plug :resp

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
    # required
    :ets.new(:session, [:named_table, :public, read_concurrency: true])
  end

  def resp(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, Plug.CSRFProtection.get_csrf_token)
  end
end
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
* Cookies:クッキー便利メソッド
* Query: クエリーストリング便利メソッド
* Conn.Status: ステータスコード便利メソッド
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

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    raise "oops"
  end
end
```

---
# Plug.ErrorHandler
* 文字通りエラーハンドリングするplug

```elixir
defmodule ElixirPlugExamples.ErrorHandlerPlug do
  import Plug.Conn
  use Plug.ErrorHandler

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

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
  * 何故…

```elixir
Plug.HTML.html_escape("<foo>")
```

---
# Plug.Head

---
Plug.Logger
Plug.MIME
Plug.MethodOverride
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
Plug.Static
Plug.Test
Plug.Upload

