defmodule Mercury.Batch do
  alias Mercury.{Repo, Batch.Batch}
  import Ecto.Query

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
  Retrieve a batch by ID. Returns `nil` if no result was found.
  """
  def get(id) do
    Repo.get(Batch, id)
  end

  @doc """
  List all sent batches
  """
  def list(opts \\ []) do
    query = case Keyword.get(opts, :email) do
      nil ->
        from b in Batch
      email ->
        from b in Batch,
        where: fragment("creator->>'email' = ?", ^email)
    end
    Repo.all(query)
  end

  @doc """
  Update a Batch 
  """
  def update(batch, attrs \\ %{}) do
    batch
    |> Batch.change(attrs)
    |> Batch.validate()
    |> Repo.update()
  end
end
