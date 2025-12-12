from pydantic import BaseModel, Field
from lancedb.embeddings import get_registry
from lancedb.pydantic import LanceModel, Vector
from dotenv import load_dotenv

load_dotenv()
# For Gemini: embedding_model = get_registry().get("gemini-text").create(name="gemini-embedding-001")
embedding_model = get_registry().get("openai").create(name="text-embedding-3-small")


EMBEDDING_DIM = 1536

class Article(LanceModel):
    doc_id: str
    filepath: str
    filename: str = Field(description="the stem of the file i.e. without the suffix")
    content: str = embedding_model.SourceField()
    embedding: Vector(EMBEDDING_DIM) = embedding_model.VectorField()
    

class Prompt(BaseModel):
    prompt: str = Field(escription="prompt from user, if empty consider it as missing")
    
class RagResponse(BaseModel):
    filename: str = Field(description="filename of retrieved file without suffix")
    filepath: str = Field(description="absolute path to the retrieved file") 
    answer: str = Field(description="answer based on the retrieved file") 
    
class History(BaseModel):
    role:str
    content:str

