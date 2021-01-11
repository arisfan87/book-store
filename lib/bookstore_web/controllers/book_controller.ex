defmodule BookstoreWeb.BookController do
  use BookstoreWeb, :controller
  require Logger
  alias BookstoreWeb.Router
  alias Bookstore.Book
  alias Bookstore.Author
  alias Bookstore.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    render(conn, "index.html", books: Repo.all(Book))
  end

  def show(conn, %{"id" => id}) do
    
    case Repo.get(Book, id) do
      book when is_map(book) ->
        render conn, "show.html", book: book
      _ ->
        redirect conn, to: Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end
  
  def new(conn, _params) do
    query = from(a in Author, select: {a.email_address, a.id})
    authors = Repo.all(query)
    conn
  |> assign(:changeset, Book.changeset(%Book{}))
  |> assign(:authors, authors)
  |> render("new.html")
  end

  def create(conn, %{"book" => book_params}) do
    changeset = Book.changeset(%Book{}, book_params)
    case Repo.insert(changeset) do
      {:ok, _book} ->
        conn
        |> put_flash(:info, "Book created successfully.")
        |> redirect(to: Routes.book_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, authors: Repo.all(from a in Author, select: {a.email_address, a.id}))
    end
  end

  def edit(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)
    changeset = Book.changeset(book)
    query = from(a in Author, select: {a.email_address, a.id})
    authors = Repo.all(query)
    conn
    |> assign(:changeset, changeset)
    |> assign(:authors, authors)
    |> assign(:book, book)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = Repo.get!(Book, id)
    changeset = Book.changeset(book, book_params)

    case Repo.update(changeset) do
      {:ok, book} ->
        conn
        |> put_flash(:info, "Book updated successfully.")
        |> redirect(to: Routes.book_path(conn, :show, book, authors: Repo.all(from a in Author, select: {a.email_address, a.id})))
      {:error, changeset} ->
        render(conn, "edit.html", book: book, changeset: changeset, authors: Repo.all(from a in Author, select: {a.email_address, a.id}))
    end
  end

  def delete(conn, %{"id" => id}) do
    book = Repo.get!(Book, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(book)

    conn
    |> put_flash(:info, "Book deleted successfully.")
    |> redirect(to: Routes.book_path(conn, :index))
  end
end