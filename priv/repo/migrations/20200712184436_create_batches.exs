defmodule Mercury.Repo.Migrations.CreateBatches do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :body, :text
      add :bcc, :string
      add :cc, :string
      add :creator, :map
      add :from, :string
      add :from_name, :string
      add :send_report, {:array, :map}
      add :subject, :string
      add :table_data, :text
      add :to, :string

      timestamps()
    end

  end
end
