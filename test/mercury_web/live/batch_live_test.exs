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

    test "delivering emails", %{conn: conn} do
      state = batch_state()
      {batch, changeset} = 
        conn
        |> assign(:state, state)
        |> MercuryWeb.BatchLive.Index.send_emails()
      assert Enum.count(Ecto.Changeset.get_change(changeset, :send_report)) == 3
      Enum.each batch.send_report, fn report ->
        assert report.status == ":delivered_email"
        assert_delivered_email report.bamboo_email
      end

      assert Enum.count(Mercury.Batch.list()) == 1
    end
  end
end
