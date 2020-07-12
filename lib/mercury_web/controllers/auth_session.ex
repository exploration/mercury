defmodule MercuryWeb.AuthSession do
  @moduledoc "Session management for authentication"

  import Plug.Conn
  alias Mercury.Account

  def init(options), do: options

  # Maintain an account in the conn if logged in
  def call(conn, _options) do
    cond do
      conn.assigns[:account] -> conn
        
      get_session(conn, :account) -> conn

      true -> assign(conn, :account, nil)
    end
  end

  @doc "Test login"
  def logged_in?(conn) do
    get_session(conn, :account)
  end

  @doc "Test login, given a session map (like in a liveview)"
  def logged_in_session?(session) do
    %Mercury.Account{email: _email} = Map.get(session, :account, %Account{})
  end

  @doc "Login adds an account to the session storage"
  def login(conn, account) do 
    conn
    |> assign(:account, account)
    |> put_session(:account, account)
    |> configure_session(renew: true)
  end

  @doc "Logging out drops the entire session"
  def logout(conn) do
    conn
    |> assign(:account, nil)
    |> delete_session(:account)
  end
end
