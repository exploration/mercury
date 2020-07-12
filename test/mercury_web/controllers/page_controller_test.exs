defmodule MercuryWeb.PageControllerTest do
  use MercuryWeb.ConnCase, async: true
  alias MercuryWeb.AuthSession

  describe "not logged in" do
    test "index requires login", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Log in"
    end
  end

  describe "logged in" do
    setup [:login]
    test "logged in redirects to batches", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))
      assert redirected_to(conn, 302) == Routes.batch_index_path(conn, :index)
    end

    test "logout", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :delete))
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
      refute AuthSession.logged_in?(conn)
    end
  end
end
