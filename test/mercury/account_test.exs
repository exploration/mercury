defmodule Mercury.AccountTest do
  use Mercury.DataCase, async: true
  alias Mercury.Account

  @google_profile %{
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

  test "conversion from google auth profile struct" do
    assert %Account{} = Account.from_google_profile(@google_profile)
  end
end
