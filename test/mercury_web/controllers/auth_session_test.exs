defmodule MercuryWeb.AuthSessionTest do
  use MercuryWeb.ConnCase, async: true
  alias Mercury.Account
  alias MercuryWeb.AuthSession

  describe "logged in" do
    setup [:login]

    test "works", %{conn: conn, account: account} do
      assert %Account{} = account
      assert AuthSession.logged_in? conn
    end
  end
end
