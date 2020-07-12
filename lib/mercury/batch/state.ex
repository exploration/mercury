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
end
