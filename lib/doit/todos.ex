defmodule Doit.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias Doit.Repo

  alias Doit.Todos.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos(_params \\ %{}) do
    #Repo.all(Todo)
    Repo.all(from t in Todo, order_by: [desc: t.importance])
    #list by Todo importance
    #from(
    #  t in Todo,
    #  order_by: ^filter_order_by(params["order_by"])
    #  )
    #|> Repo.all(from t in Todo, order_by: [desc: t.importance])
  end

  defp filter_order_by("importance_desc"), do: [desc: :importance]
  defp filter_order_by("id_desc"), do: [desc: :id]
  defp filter_order_by(_), do: []

  def inc_importance(id) do
    #perform a atomic increment of the importance counter
    #check via changset if incrementation is valid

    #IO.puts(from(t in Todo, where: t.id == ^id, select: t))

    {1, [todo]} =
      from(t in Todo, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [importance: 1])

    broadcast({:ok, todo}, :todo_updated_importance)
  end

  def dec_importance(id) do
    #perform a atomic increment of the importance counter
    {1, [todo]} =
      from(t in Todo, where: t.id == ^id, select: t)
      |> Repo.update_all(inc: [importance: -1])

    broadcast({:ok, todo}, :todo_updated_importance)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:todo_created)
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast(:todo_updated)
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    todo
    |> Repo.delete()
    |> broadcast(:todo_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Doit.PubSub, "todos")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, todo}, event) do
    Phoenix.PubSub.broadcast(Doit.PubSub, "todos", {event, todo})
    {:ok, todo}
  end
end
