defmodule MercuryWeb.PageController do
  use MercuryWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, _params) do
    oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
    render(conn, "index.html",[oauth_google_url: oauth_google_url])
  end
end
