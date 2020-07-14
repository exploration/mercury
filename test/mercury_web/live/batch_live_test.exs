defmodule MercuryWeb.BatchLiveTest do
  use MercuryWeb.ConnCase, async: true
  use Bamboo.Test
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

    test "delivering emails" do
      state = batch_state()
      Enum.with_index(state.table.rows)
      |> Enum.each(fn {_row, index} ->
        report = MercuryWeb.BatchLive.Index.send_email(state, index)
        assert report.status == ":delivered_email"
        assert_delivered_email report.bamboo_email
      end)
    end
  end
end
