import { useState, type FormEvent } from "react";
import AnswerCard from "./Answer";
import stackoverflow from "../assets/stackoverflow.svg";
import ReactMarkdown from "react-markdown";

const Home = () => {
  const [answersList, setAnswersList] = useState([]);
  const [answersAIShuffled, setAnswersAIShuffled] = useState(null);
  const [isAIResult, setISAIResult] = useState(false);
  const [question, setQuestion] = useState("");

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const question = (e.currentTarget.elements.namedItem('question') as HTMLInputElement).value;
    setQuestion(question);
    const url = encodeURI(`http://localhost:4000/api/search?question=${question}`);

    const response = await fetch(url);
    const fetch_answers = await response.json();
    const { answers_list: answers_list } = fetch_answers;
    setAnswersList(answers_list);
    setISAIResult(false);
  }

  const handleShuffleViaAI = async () =>  {    
    const url = encodeURI(`http://localhost:4000/api/filter_results?question=${question}`);
    
    setISAIResult(true);
    const response = await fetch(url);
    const fetch_ai_results = await response.json();
    const { response: response_results } = fetch_ai_results;

    setAnswersAIShuffled(response_results);
  }
  
  return(
    <div className="min-h-screen bg-gray-50 flex flex-col items-center justify-start pt-8 px-4">
      <div className="max-w-4xl mx-auto">
        <div className="mb-6 p-4 bg-white hover:bg-gray-300 text-white rounded-t">
          <img src={stackoverflow} />
        </div>
        <div className="flex justify-center">
          <div className="bg-white p-4 shadow rounded mb-6 w-full max-w-2xl">
            <form onSubmit={handleSubmit} className="flex gap-2">
              <input
                type="text"
                name="question"
                placeholder="What do you want to know?"
                className="flex-1 border border-gray-300 rounded px-4 py-2 text-base focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />

              <button 
                type="submit"
                className="px-6 py-2 rounded bg-gray-600 text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                Search
              </button>

              <button 
                type="button"
                className= {`px-6 py-2 rounded bg-gray-600 text-white hover:bg-blue-600 focus:outline-none  ${question == "" ? "cursor-not-allowed" : ""}`}
                onClick={handleShuffleViaAI}
                disabled={question == ""}
              >
                Shuffle using AI
          </button>
            </form>
          </div>
        </div>

        <div className="gap-x-10 py-4 text-xl">
           {question}
        </div>

    {/* could have dealt this in much better way, */}
    {/* When AI answer is available we hide this */}
      {!isAIResult &&
          <div className="bg-white p-4 shadow rounded">
            <h2 className="text-xl font-semibold mb-4 pb-2 border-b border-gray-200">Answers</h2>
            
            {answersList.length > 0 ? (
              answersList.map((answer, index) => (
                <div key={index} className="mb-6 pb-6 border-b border-gray-200 last:border-b-0 last:pb-0 last:mb-0">
                  <AnswerCard
                    markdown={answer["answer"]}
                    votes={answer["score"]}
                    isAccepted={answer["is_accepted"]}
                  />
                </div>
              ))
            ) : (
              <div className="text-center py-8 text-gray-500">
                No answers yet. Ask a question to get started!
              </div>
            )}
          </div>
      }

        {
          isAIResult && 
          <>
            <div className="gap-x-10 py-4 text-xl">
              AI Suggestion 
            </div>
            <div className="prose mx-auto p-4">
              <ReactMarkdown>{answersAIShuffled}</ReactMarkdown>
            </div>
          </>
        }
   
      </div>
    </div>
  );
};

export default Home;