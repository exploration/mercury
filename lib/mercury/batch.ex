defmodule Mercury.Batch do
  alias Mercury.{Repo, Batch.Batch}

  @doc """
  Given valid `attrs` as a map, create a %Mercury.Batch.Batch{}.

  ## Examples
  
      iex> create(%{from: "from@from.org"})
      {:ok, %Batch{from: "from@from.org", ...}}
  """
  def create(attrs \\ %{}) do
    %Batch{}
    |> Batch.change(attrs)
    |> Batch.validate()
    |> Repo.insert() 
  end
end
