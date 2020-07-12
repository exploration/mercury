defmodule Mercury.Account do
  defstruct [:email, :email_verified, :family_name, :given_name, :hd, :locale, :picture, :profile, :sub] 

  @doc """
  Given a profile from a Google Auth callback, convert to an %Account{}.

  ## Examples
  
      iex> {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
      iex> from_google_profile(profile)
      %Account{}

  """
  def from_google_profile(profile) do
    Map.merge %__MODULE__{}, profile
  end
end
