defmodule MercuryWeb.GoogleAuthController do
  use MercuryWeb, :controller
  alias Mercury.Account
  alias MercuryWeb.AuthSession

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    account = Account.from_google_profile(profile)

    conn
    |> AuthSession.login(account)
    |> redirect(to: "/")
  end
end
