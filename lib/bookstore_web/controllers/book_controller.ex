defmodule BookstoreWeb.BookController do
  use BookstoreWeb, :controller
  require Logger
  alias BookstoreWeb.Router
  alias Bookstore.Book
  alias Bookstore.Author
  alias Bookstore.Repo
  import Ecto.Query, only: [from: 2]

  #Logger.debug "Var value: #{inspect(books)}"
  
  def index(conn, _params) do
    conn
    |> assign(:books, Book |> Repo.all)
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Book, id) do
      book when is_map(book) ->
      conn
      |> assign(:book, book)
      |> render("show.html")
      _ ->
        redirect conn, to: Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end
  
  def new(conn, _params) do
    query = from(a in Author, select: {a.email_address, a.id})
    conn
    |> assign(:changeset, Book.changeset(%Book{}))
    |> assign(:authors, Repo.all(query))
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
        render(
          conn
          |> assign(:changeset, changeset)
          |> assign(:authors, Repo.all(from a in Author, select: {a.email_address, a.id}))
          |> render("new.html")
        )
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
        |> redirect(to: Routes.book_path(
          conn
          |> assign(:changeset, changeset)
          |> assign(:authors, Repo.all(from a in Author, select: {a.email_address, a.id}))
          |> assign(:book, book)
          |> render("edit.html"))
          )
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:authors, Repo.all(from a in Author, select: {a.email_address, a.id}))
        |> assign(:book, book)
        |> render("edit.html")
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