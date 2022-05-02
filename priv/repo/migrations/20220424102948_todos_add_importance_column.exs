defmodule Doit.Repo.Migrations.TodosAddImportanceColumn do
  use Ecto.Migration

  def change do
    alter table("todos") do
      add :importance, :integer, default: 0
    end

  end
end
