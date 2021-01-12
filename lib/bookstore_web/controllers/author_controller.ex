defmodule BookstoreWeb.AuthorController do
  use BookstoreWeb, :controller
  import Ecto.Query, only: [from: 2]
  require Logger

  alias BookstoreWeb.Router
  alias Bookstore.Author
  alias Bookstore.Book
  alias Bookstore.Repo

  def index(conn, _params) do
    render(conn, "index.html", authors: Repo.all(Author))
  end

  def show(conn, %{"id" => id}) do
    books = Book
            |> Book.get_author_books(id)
            |> Repo.all

    Logger.debug "Var value: #{inspect(books)}"

    case Repo.get(Author, id) do
      author when is_map(author) ->
        render conn
        |> assign(:books, books)
        |> assign(:author, author)
        |> render("show.html")
      _ ->
        redirect conn, to: Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end

  def new(conn, _params) do
    changeset = Author.changeset(%Author{}, _params)
      conn
      |> assign(:changeset, changeset)
      |> render("new.html")
  end

  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)
    case Repo.insert(changeset) do
      {:ok, _author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: Routes.author_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author)
      conn
      |> assign(:changeset, changeset)
      |> assign(:author, author)
      |> render("edit.html")
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author, author_params)

    case Repo.update(changeset) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: Routes.author_path(conn, :show, author))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:author, author)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(author)

    conn
    |> put_flash(:info, "Author deleted successfully.")
    |> redirect(to: Routes.author_path(conn, :index))
  end
end