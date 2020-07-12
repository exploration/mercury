defmodule MercuryWeb.PageController do
  use MercuryWeb, :controller
  alias MercuryWeb.AuthSession

  @doc """
  Show the login button and/or redirect to the batch view
  """
  def index(conn, _params) do
    if AuthSession.logged_in?(conn) do
      redirect(conn, to: Routes.batch_index_path(conn, :index))
    else
      oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
      render(conn, "index.html", [oauth_google_url: oauth_google_url])
    end
  end
end
