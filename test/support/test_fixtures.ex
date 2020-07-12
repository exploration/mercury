defmodule Mercury.TestFixtures do
  @doc "a valid %Mercury.Account{}"
  def account(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      email: "dmerand@explo.org",
      email_verified: true,
      family_name: "Merand",
      given_name: "Donald",
      hd: "explo.org",
      locale: "en",
      name: "Donald Merand",
      picture: "https://lh3.googleusercontent.com/a-/AOh14Ghgy8pFmrNErrBfqvg82xRuMim0_46P1M4TtY7GGg",
      profile: "https://plus.google.com/117575961915318464047",
      sub: "117575961915318464047"
    })
    |> Mercury.Account.from_google_profile()
  end


  @doc """
  Run this in a test setup block to log in.
  For more info: https://hexdocs.pm/ex_unit/1.10.3/ExUnit.Callbacks.html#module-context

  ## Examples
      describe "test area" do
        setup [:login]
        test "some test", %{conn: conn, account: account}, do: assert true
      end
  """
  def login(%{conn: conn}) do
    account = account()
    conn = 
      Plug.Conn.assign(conn, :account, account)
      |> Plug.Test.init_test_session(%{account: account})
    {:ok, conn: conn, account: account}
  end
end
