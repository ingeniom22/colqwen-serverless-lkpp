import runpod
from byaldi import RAGMultiModalModel


RAG = RAGMultiModalModel.from_index("../byaldi/lkpp-multimodal")

def handler(job):
    job_input = job["input"]
    query = job_input["query"]

    results = RAG.search(query=query, k=5)

    return results


runpod.serverless.start({"handler": handler})