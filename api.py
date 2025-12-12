from fastapi import FastAPI
from backend.rag import rag_agent, RagResponse
from backend.data_models import Prompt, History
from typing import List

app = FastAPI()

last_result = None
chat_history: List[History] = []   

@app.post("/chatbot/query", response_model=RagResponse)
async def ask_botagent(query: Prompt):
    global last_result, chat_history
    
    #stores user input for history endpoint
    chat_history.append(History(role="user", content=query.prompt))
    
    #stores memory
    message_history = last_result.all_messages() if last_result else None

    result = await rag_agent.run(
        query.prompt,
        message_history=message_history,
    )

    last_result = result
    answer = result.output.answer
    
    #Stores bots answer to endpoint
    chat_history.append(History(role="assistant", content=answer))
    return result.output


@app.get("/chatbot/history", response_model=List[History])
async def get_history():
        return chat_history
