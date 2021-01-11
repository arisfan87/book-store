defmodule Bookstore.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
      add :email_address, :string

      timestamps()
    end

    create unique_index(:authors, [:email_address])
  end
end
