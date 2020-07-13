defmodule Mercury.Batch.State do
  @moduledoc """
  This is the "state" of a given Batch in the app. It's used to hold information about where in the process the current Batch is located. It also contains logic for phase comparison.

  The Batch can be in one of three phases:

  - "new" - No table data has been entered, we're just starting
  - "parsed" - Table data has been entered, but we haven't sent any emails yet
  - "sent" - Emails have been sent and we're now looking at a saved Batch.
  """

  alias Mercury.{Account, Table}
  alias Mercury.Batch.Batch

  defstruct [
    account: %Account{}, 
    batch: %Batch{},
    changeset: Batch.change(%Batch{}, %{}),
    phase: "new",
    selected_row: 0,
    table: %Table{},
    updating: false,
  ]
  
  @field_regex ~r/{{([a-zA-Z0-9 -_]+)}}/

  @doc """
  Given a State, return the appropriate phase
  """
  def assign_phase(state) do
    case state do
      %{batch: %Batch{id: id}} when not is_nil(id) ->
        %{state| phase: "sent"}
      %{batch: %Batch{table_data: nil}} ->
        %{state| phase: "new"}
      _ -> 
        %{state| phase: "parsed"}
    end
  end

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
  Given a state and a form field name, return the interpolated value of the given form field's value for the currently-selected row in the state.

  ## Examples
  
      iex> merge(state, :from)
      "donald@merand.org"

      iex> merge(state_with_no_form, :from)
      ""
  """
  def merge(state, field) do
    template = Ecto.Changeset.get_field(state.changeset, field)
    if template == nil || state.table.field_count == 0 do
      nil
    else
      Regex.split(@field_regex, template, include_captures: true)
      |> Enum.map(fn part ->
        case Regex.run(@field_regex, part) do
          nil ->
            part
          [_string, field_name] ->
            Table.get_field(state.table, state.selected_row, field_name)
        end
      end)
      |> Enum.join()
    end
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
