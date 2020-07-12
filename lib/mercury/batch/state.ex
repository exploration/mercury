defmodule Mercury.Batch.State do
  alias Mercury.{Account, Table}
  alias Mercury.Batch.Batch

  defstruct [
    account: %Account{}, 
    batch: %Batch{},
    changeset: Batch.changeset(%Batch{}, %{}),
    phase: "new",
    table: %Table{}
  ]

  @doc """
  Returns `true` if the state is precisely at the specified phase

  ## Examples
  
      iex> at_phase %State{}, "new"
      true

      iex> at_phase %State{}, "parsed"
      false
  """
  def at_phase(%__MODULE__{} = state, phase) do
    state.phase == phase
  end

  @doc """
  Returns `true` if the state is at or after the specified phase

  ## Examples
  
      iex> up_to_phase %State{phase: "parsed"}, "new"
      true

      iex> up_to_phase %State{phase: "parsed"}, "parsed"
      true

      iex> up_to_phase %State{phase: "new"}, "parsed"
      false
  """
  def up_to_phase(%__MODULE__{} = state, phase) do
    phases = ["new", "parsed", "sent"]
    match(phases, state.phase) >= match(phases, phase)
  end

  defp match(list, match) do
    Enum.find_index(list, fn item -> item == match end) || 0
  end
end
