defmodule ExampleAppWeb.Hooks.SetLocale do
  import Phoenix.Component

  def on_mount(:default, _params, session, socket) do
    locale = session["locale"]
    Gettext.put_locale(locale)

    {:cont, assign(socket, :locale, locale)}
  end
end
