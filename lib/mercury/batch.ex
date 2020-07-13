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

  @doc """
  List all sent batches
  """
  def list() do
    Repo.all(Batch)
  end
end
