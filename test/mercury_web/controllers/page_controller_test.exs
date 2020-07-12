defmodule MercuryWeb.PageControllerTest do
  use MercuryWeb.ConnCase, async: true

  test "index requires login", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Log in"
  end
end
