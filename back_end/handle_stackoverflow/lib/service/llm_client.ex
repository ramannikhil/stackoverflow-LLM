defmodule Service.LlmClient do
  alias Service.Question
  import Plug.Conn

  @ollama_url "http://127.0.0.1:11434/api/generate"

  def chat_completion(conn, question) do
    answers_list = Question.fetch_answers_for_question(question)

    prompt =
      "
        Below are the question and answers list,
        Can you analyze best related answers for the given question?
        Please provide the detailed answer and in a bulleted list format, donot shrink it
        question:
        #{question}

        answers list:
        #{inspect(answers_list)}
      "

    body =
      %{
        "model" => "llama3.2",
        "prompt" => prompt
      }
      |> Jason.encode!()

    headers = [
      {"Content-Type", "application/json"}
    ]

    request = Finch.build(:post, @ollama_url, headers, body)

    case Finch.request(request, HandleStackoverflow.Finch) do
      {:ok, %Finch.Response{status: 200, body: resp_body}} ->
        responses =
          resp_body
          |> String.split("\n", trim: true)
          |> Enum.map(&Jason.decode!/1)

        # # Combine all responses
        combined_response = Enum.map(responses, & &1["response"]) |> Enum.join()

        conn
        |> Phoenix.Controller.json(%{response: combined_response})

      _ ->
        send_resp(
          conn,
          500,
          "Internal error while fetching the results from the LLM"
        )
    end
  end
end
