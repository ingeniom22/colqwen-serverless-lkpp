import runpod
from byaldi import RAGMultiModalModel


RAG = RAGMultiModalModel.from_index("../byaldi/lkpp-multimodal")

def handler(job):
    query = job["query"]

    results = RAG.search(query=query, k=5)

    return results


runpod.serverless.start({"handler": handler})