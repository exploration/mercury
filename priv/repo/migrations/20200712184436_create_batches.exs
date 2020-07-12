defmodule Mercury.Repo.Migrations.CreateBatches do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :body, :text
      add :cc, :string
      add :creator, :map
      add :from, :string
      add :send_report, :text
      add :subject, :string
      add :table_data, :text
      add :to, :string

      timestamps()
    end

  end
end
