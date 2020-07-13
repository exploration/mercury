defmodule Mercury.Batch.Batch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batches" do
    field :body, :string
    field :cc, :string
    field :bcc, :string
    field :creator, :map
    field :from, :string
    field :from_name, :string
    field :send_report, {:array, :map}
    field :subject, :string
    field :table_data, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def change(batch, attrs) do
    batch
    |> cast(attrs, [:table_data, :creator, :send_report, :from, :from_name, :to, :cc, :bcc, :subject, :body])
  end

  @doc false
  def validate(changeset) do
    changeset
    |> validate_required([:table_data, :creator, :from, :from_name, :to, :subject, :body])
  end
end
