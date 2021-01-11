defmodule Bookstore.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :isbn, :string
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:books, [:isbn])
    create index(:books, [:author_id])
  end
end
