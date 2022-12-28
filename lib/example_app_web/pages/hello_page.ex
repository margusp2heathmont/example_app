defmodule ExampleAppWeb.Login do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(username password)a
  @optional_fields []

  embedded_schema do
    field(:username, :string)
    field(:password, :string)
  end

  def changeset(%__MODULE__{} = login, params \\ %{}) do
    login
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end


defmodule ExampleAppWeb.HelloPage do
  use Phoenix.LiveView
  use Phoenix.HTML
  import Phoenix.HTML.Form
  import ExampleAppWeb.ErrorHelpers

  def render(assigns) do
    ~H"""
    Changeset:
    <%= inspect(@changeset) %>
    Locale:
    <%= inspect(@locale) %>
    <.form :let={f} for={@changeset} phx-change="update" action="/example" method="post">
      <%= label f, :username %>
      <%= text_input f, :username %>
      <%= error_tag f, :username %>

      <%= label f, :password %>
      <%= text_input f, :password %>
      <%= error_tag f, :password %>

      <%= submit "Save" %>
    </.form>
    """
  end

  def mount(params, session, socket) do
    IO.puts(inspect(session))

    socket = if session["changeset"] do
      assign(socket, changeset: session["changeset"])
    else
      assign(socket, changeset: ExampleAppWeb.Login.changeset(%ExampleAppWeb.Login{}, %{}))
    end

    socket = if session["locale"] do
      assign(socket, locale: session["locale"])
    else
      # already comes from Hook
      socket
    end

    {:ok, socket}
  end

  def handle_event("update", params, socket) do
    changeset = ExampleAppWeb.Login.changeset(%ExampleAppWeb.Login{}, params["login"])
    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end
end
