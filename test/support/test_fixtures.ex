defmodule Mercury.TestFixtures do
  alias Mercury.{Account, Batch, Batch.State, Table}

  @doc """
  Returns a valid %Mercury.Account{}. `attrs` can be passed as a map.
  """
  def account(attrs \\ %{}) do
    attrs
    |> Enum.into(account_attrs())
    |> Account.from_google_profile()
  end

  @doc """
  Map attributes for a valid %Mercury.Account{}. This is basically a Google Profile.

  ## Examples
  
      iex> account_attrs()
      %{...}

      iex> %{account_attrs() | email: "ellery@merand.org"}
      %{email: "ellery@merand.org", ...}
  """
  def account_attrs() do
    %{
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
    }
  end

  @doc """
  Map attributes for a valid %Mercury.Batch.Batch{}.

  ## Examples
  
      iex> batch_attrs()
      %{...}

      iex> %{batch_attrs() | from: "ellery@merand.org"}
      %{from: "ellery@merand.org", ...}
  """
  def batch_attrs() do
    %{
      body: "test body {{First Name}}",
      cc: "cc@cc.org",
      creator: account(),
      from: "from@from.org",
      send_report: [%{status_code: 200, headers: [""], body: "cool"}],
      subject: "test subject",
      table_data: table_data(),
      to: "{{Email}}"
    }
  end

  @doc """
  Returns a valid %Mercury.Batch.Batch{}. `attrs` can be passed as a map.
  """
  def batch(attrs \\ %{}) do
    Mercury.Batch.Batch.change(%Mercury.Batch.Batch{}, Map.merge(attrs, batch_attrs()))
    |> Ecto.Changeset.apply_changes()
  end

  @doc """
  Returns a valid %Mercury.Batch.State{}. `attrs` can be passed as a map.
  """
  def batch_state(attrs \\ %{}) do
    Map.merge %State{}, Enum.into(attrs, %{
      account: account(),
      batch: batch(),
      changeset: Batch.Batch.change(%Batch.Batch{}, batch_attrs()),
      table: Table.from_tsv(table_data())
    })
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
      |> Plug.Test.init_test_session(%{"account" => account})
    {:ok, conn: conn, account: account}
  end

  @doc "raw TSV data"
  def table_data do
    "First Name\tLast Name\tEmail\nDonald\tMerand\tdmerand@explo.org\nEric\tEdwards\teedwards@explo.org\nSam\tOsborn\tsosborn@explo.org"
  end
end
