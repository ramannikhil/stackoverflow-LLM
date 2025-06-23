defmodule HandleStackoverflowWeb.ApiController do
  alias Service.FetchQuestion
  use HandleStackoverflowWeb, :controller
  alias Service.LlmClient

  def search(conn, params) do
    question = Map.get(params, "question")
    FetchQuestion.request(conn, question)
  end

  def filter_results(conn, params) do
    question = Map.get(params, "question")
    LlmClient.chat_completion(conn, question)
  end
end
