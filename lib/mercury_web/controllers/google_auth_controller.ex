defmodule MercuryWeb.GoogleAuthController do
  use MercuryWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    conn
    |> render(:welcome, profile: profile)
  end
end
