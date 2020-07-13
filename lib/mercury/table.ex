defmodule Mercury.Table do
  alias Mercury.Row

  defstruct field_count: 0, header: %Row{}, rows: [], row_count: 0

  @doc """
  Given a valid TSV, convert it into a %Table{}
  """
  def from_tsv(nil), do: nil
  def from_tsv(tsv) do
    [header | rows] = 
      tsv
      |> String.split("\n")
      |> Enum.map(&Row.from_tsv_row/1)

    %__MODULE__{
      field_count: Enum.count(header.fields),
      header: header,
      rows: rows,
      row_count: Enum.count(rows)
    }
  end

  @doc """
  Given a table, row number, and field name, return the matching row/field. If no field is found, return an empty string.

  ## Examples
  
      iex> get_field(table, 2, "First Name")
      "Donald"
  """
  def get_field(%__MODULE__{} = table, row_number, field_name) do
    field_index = Enum.find_index(table.header.fields, fn field -> field == field_name end)

    cond do
      row_number > table.row_count ->
        ""
      field_index == nil ->
        ""
      true ->
        table.rows
        |> Enum.at(row_number)
        |> Map.get(:fields, [])
        |> Enum.at(field_index)
    end
  end
end
