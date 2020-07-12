defmodule Mercury.Row do
  defstruct fields: []

  def from_tsv_row(row) do
    %__MODULE__{
      fields: String.split(row, "\t")
    }
  end
end
