defmodule Bookstore.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :email_address, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(author , attrs \\ %{}) do
    author
    |> cast(attrs, [:name, :email_address])
    |> validate_required([:name, :email_address])
    |> unique_constraint(:email_address)
  end
end
