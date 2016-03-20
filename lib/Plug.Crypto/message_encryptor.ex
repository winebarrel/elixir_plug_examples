defmodule ElixirPlugExamples.MessageEncryptorPlug do
  import Plug.Conn

  def start do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 9001
  end

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    # see https://hexdocs.pm/plug/Plug.Crypto.MessageEncryptor.html
    secret_key_base = "072d1e0157c008193fe48a670cce031faa4e..."
    encrypted_cookie_salt = "encrypted cookie"
    encrypted_signed_cookie_salt = "signed encrypted cookie"

    secret = Plug.Crypto.KeyGenerator.generate(secret_key_base, encrypted_cookie_salt)
    sign_secret = Plug.Crypto.KeyGenerator.generate(secret_key_base, encrypted_signed_cookie_salt)

    data = "José"
    encrypted = Plug.Crypto.MessageEncryptor.encrypt_and_sign(data, secret, sign_secret)
    {:ok, decrypted} = Plug.Crypto.MessageEncryptor.verify_and_decrypt(encrypted, secret, sign_secret)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, decrypted)
  end
end

#mix run --no-halt -e ElixirPlugExamples.MessageEncryptorPlug.start
