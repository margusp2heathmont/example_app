defmodule ExampleAppWeb.Plug.LocalePlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _) do
    conn = fetch_session(conn)
    put_session(conn, :locale, "en")
  end
end
