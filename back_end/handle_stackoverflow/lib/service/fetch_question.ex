defmodule Service.FetchQuestion do
  import Plug.Conn
  alias Service.Question

  def request(conn, question) do
    resp = build_and_fetch(question)

    case resp do
      {:ok,
       %Finch.Response{
         status: 200,
         body: body
       }} ->
        decoded_body = Jason.decode!(body)
        %{"items" => items} = decoded_body

        questions_list =
          Enum.map(items, fn %{"question_id" => question_id} -> question_id end)
          |> Enum.join(";")

        final_resp = fetch_answers(questions_list)

        case final_resp do
          {:ok,
           %Finch.Response{
             status: 200,
             body: body
           }} ->
            %{"items" => items} = Jason.decode!(body)

            answers_list =
              Enum.map(items, fn %{
                                   "body_markdown" => body_markdown,
                                   "score" => score,
                                   "is_accepted" => is_accepted
                                 } ->
                %{answer: body_markdown, score: score, is_accepted: is_accepted}
              end)

            # insert records for user fetched questions
            # for simplicity hardcoded the user_id
            params = %{"user_id" => "123456", "question" => question, "answers" => answers_list}
            Question.create_question_for_user(params)

            conn
            |> Phoenix.Controller.json(%{answers_list: answers_list})

          _ ->
            send_resp(
              conn,
              500,
              "Internal error while fetching the answers"
            )
        end

      {:error, reason} ->
        send_resp(
          conn,
          500,
          "Internal error while fetching the questions, #{inspect(reason)}"
        )
    end
  end

  defp build_and_fetch(question) do
    encoded_question = URI.encode(question)
    System.get_env("STACKOVERFLOW_KEY")

    Finch.build(
      :get,
      "https://api.stackexchange.com/2.3/search/advanced?key=U4DMV*8nvpm3EOpvf69Rxw((&site=stackoverflow&order=desc&sort=votes&q=#{encoded_question}&closed=false&filter=!nNPvSNe7D9"
    )
    |> Finch.request(HandleStackoverflow.Finch)
  end

  defp fetch_answers(questions_list) do
    Finch.build(
      :get,
      "https://api.stackexchange.com/2.3/questions/#{questions_list}/answers?key=U4DMV*8nvpm3EOpvf69Rxw((&site=stackoverflow&order=desc&sort=votes&filter=!nNPvSNe7D9"
    )
    |> Finch.request(HandleStackoverflow.Finch)
  end
end
