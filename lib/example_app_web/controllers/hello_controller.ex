defmodule ExampleAppWeb.HelloController do
  use ExampleAppWeb, :controller
  import Phoenix.LiveView.Controller

  # POST from LiveView
  def try_to_log_in(conn, %{"login" => login_params} = params) do
    session = get_session(conn)
    # this comes from plug, but needs to be manually set here, because hook is not executed
    locale = session["locale"]

    if login_params["username"] == "hello" && login_params["password"] == "passw0rd" do
      session_token = "secret123"

      conn
      |> configure_session(renew: true)
      |> clear_session()
      |> put_session(:session_token, session_token)
      |> put_resp_cookie("user_session", session_token,
        sign: true,
        max_age: 60 * 60 * 24 * 365,
        http_only: true,
        path: "/"
      )
      |> Phoenix.Controller.redirect(to: "/welcome")
    else
      changeset = ExampleAppWeb.Login.changeset(%ExampleAppWeb.Login{}, params["login"])
      changeset = Ecto.Changeset.add_error(changeset, :username, "Is invalid")
      changeset = Ecto.Changeset.add_error(changeset, :password, "Is invalid")

      conn
      |> live_render(ExampleAppWeb.HelloPage,
        session: %{
          "changeset" => changeset,
          # Hook is not executed, if this line is removed, then LiveView will fail
          "locale" => locale
        }
      )
    end
  end
end
