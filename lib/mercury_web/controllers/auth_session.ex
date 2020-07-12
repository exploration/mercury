defmodule MercuryWeb.AuthSession do
  @moduledoc "Session management for authentication"

  import Plug.Conn

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
    %Mercury.Account{} = Map.get(conn.assigns, :account)
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
    configure_session(conn, drop: true)
  end
end
