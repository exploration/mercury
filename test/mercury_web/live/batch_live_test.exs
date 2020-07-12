defmodule MercuryWeb.BatchLiveTest do
  use MercuryWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "Not Logged In" do
    test "index", %{conn: conn} do
      assert {:error, {:redirect, _}} = live(conn, Routes.batch_index_path(conn, :index))
    end
  end

  describe "Index" do
    setup [:login]

    test "shows when logged in", %{conn: conn, account: account} do
      {:ok, _index_live, html} = live(conn, Routes.batch_index_path(conn, :index))
    
      assert html =~ account.name
    end
  end
end
