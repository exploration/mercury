defmodule MercuryWeb.BatchController do
  use MercuryWeb, :controller
  plug MercuryWeb.RequiresAuth
  alias MercuryWeb.AuthSession
  alias Mercury.Batch

  @doc """
  Show the login button and/or redirect to the batch view
  """
  def index(conn, _params) do
    account = AuthSession.logged_in?(conn)
    batches = Batch.list(email: account.email)
    render(conn, "index.html", account: account, batches: batches)
  end
end
