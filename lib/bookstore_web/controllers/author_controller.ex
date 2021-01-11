defmodule BookstoreWeb.AuthorController do
  use BookstoreWeb, :controller

  require Logger

  alias BookstoreWeb.Router
  alias Bookstore.Author
  alias Bookstore.Repo

  def index(conn, _params) do
    render(conn, "index.html", authors: Repo.all(Author))
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Author, id) do
      author when is_map(author) ->
        render conn, "show.html", author: author
      _ ->
        redirect conn, to: Router.Helpers.page_path(conn, :show, "unauthorized")
    end
  end

  def new(conn, _params) do
    changeset = Author.changeset(%Author{}, _params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    changeset = Author.changeset(%Author{}, author_params)
    case Repo.insert(changeset) do
      {:ok, _author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: Routes.author_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author)
    render(conn, "edit.html", author: author, changeset: changeset)
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
        render(conn, "edit.html", author: author, changeset: changeset)
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