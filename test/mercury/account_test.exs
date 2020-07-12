defmodule Mercury.AccountTest do
  use Mercury.DataCase, async: true
  alias Mercury.Account

  test "conversion from google auth profile struct" do
    assert %Account{} = Account.from_google_profile(account_attrs())
  end
end
