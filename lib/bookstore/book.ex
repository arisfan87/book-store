defmodule Bookstore.Book do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Bookstore.Author
  schema "books" do
    field :isbn, :string
    field :title, :string
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs \\ %{}) do
    book
    |> cast(attrs, [:title, :isbn, :author_id])
    |> validate_required([:title, :isbn])
    |> unique_constraint(:isbn)
  end

  def get_author_books(query, id) do
    from(b in query, 
    where: b.author_id == ^id)
  end
end