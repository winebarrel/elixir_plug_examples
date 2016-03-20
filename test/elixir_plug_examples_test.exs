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

#mix test
