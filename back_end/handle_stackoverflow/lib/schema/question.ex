defmodule Schema.Question do
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "questions" do
    field(:user_id, :string)
    field(:question, :string)
    field(:answers, {:array, :map})

    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  def changeset(question, params \\ %{}) do
    question
    |> cast(params, [
      :id,
      :user_id,
      :question,
      :answers,
      :inserted_at,
      :updated_at
    ])
  end
end
