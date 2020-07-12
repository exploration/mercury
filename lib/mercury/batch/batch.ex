defmodule Mercury.Batch.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batches" do
    field :body, :string
    field :cc, :string
    field :creator, :map
    field :from, :string
    field :send_report, :string
    field :subject, :string
    field :table_data, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def change(batch, attrs) do
    batch
    |> cast(attrs, [:table_data, :creator, :send_report, :from, :to, :cc, :subject, :body])
  end

  def validate(changeset) do
    changeset
    |> validate_required([:table_data, :creator, :send_report, :from, :to, :subject, :body])
  end
end
