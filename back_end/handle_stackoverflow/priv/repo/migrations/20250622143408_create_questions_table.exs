defmodule HandleStackoverflow.Repo.Migrations.CreateQuestionsTable do
  use Ecto.Migration

  def change do
    create table("questions", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :question, :text
      add :answers, {:array, :map}

      timestamps()
    end
  end
end
