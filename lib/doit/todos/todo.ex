defmodule Doit.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Doit.Accounts.User

  schema "todos" do
    field :description, :string
    field :done, :boolean, default: false
    field :title, :string
    field :importance, :integer, default: 0

    belongs_to :user, User


    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :done, :importance])
    |> validate_required([:title, :done])
    |> validate_length(:description, min: 0, max: 250)
    |> validate_number(:importance, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
  end
end
