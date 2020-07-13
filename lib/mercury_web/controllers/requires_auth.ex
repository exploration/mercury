defmodule MercuryWeb.RequiresAuth do
  @moduledoc "Include this plug to require auth in all controller actions"

  use MercuryWeb, :controller
  alias MercuryWeb.AuthSession

  def init(options), do: options

  # Redirect to login if not logged in
  def call(conn, _options) do
    if AuthSession.logged_in?(conn) do
      conn
    else
      redirect(conn, to: Routes.page_path(conn, :index))
    end
  end
end
