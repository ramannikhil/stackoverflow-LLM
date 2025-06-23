defmodule Service.Question do
  alias Schema.Question
  alias HandleStackoverflow.Repo
  import Ecto.Query
  require Logger

  def create_question_for_user(%{"user_id" => user_id, "question" => question} = params) do
    question_exists? = question_exists_for_user?(user_id, question)

    if question_exists? do
      {:error, :question_already_exits_for_user}
    else
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      updated_params =
        params
        |> Map.merge(%{"inserted_at" => now, "updated_at" => now})

      queston_changeset = Schema.Question.changeset(%Question{}, updated_params)

      case Repo.insert(queston_changeset) do
        {:ok, created_question} ->
          Logger.info("Successfully created an question. #{inspect(created_question)}")

          # persist only previous 5 questions
          delete_other_question(user_id)

          {:ok, created_question}

        {:error, error_changeset} ->
          Logger.error(
            "Error while creating question. Changeset errors: #{inspect(error_changeset.errors)}"
          )

          {:error, :unable_to_create_question}
      end
    end
  end

  defp question_exists_for_user?(user_id, question) do
    from(x in Question, where: x.user_id == ^user_id and x.question == ^question)
    |> Repo.exists?()
  end

  def fetch_answers_for_question(question) do
    from(x in Question, where: x.question == ^question, select: x.answers)
    |> Repo.one()
    |> Enum.map(fn %{"answer" => answer} -> answer end)
  end

  defp delete_other_question(user_id) do
    latest_ids =
      from(q in Question,
        where: q.user_id == ^user_id,
        order_by: [desc: q.inserted_at],
        select: q.id
      )

    # delete older questions other than latest_ids questions
    from(q in Question,
      where: q.user_id == ^user_id and q.id not in subquery(latest_ids)
    )
    |> Repo.delete_all()
  end
end
