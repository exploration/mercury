defmodule Mercury.Table do
  alias Mercury.Row

  defstruct field_count: 0, header: %Row{}, rows: []

  def from_tsv(tsv) do
    [header | rows] = 
      tsv
      |> String.split("\n")
      |> Enum.map(&Row.from_tsv_row/1)

    %__MODULE__{
      field_count: Enum.count(header.fields),
      header: header,
      rows: rows
    }
  end
end
