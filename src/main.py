import runpod

import srsly
from byaldi import RAGMultiModalModel

index_config = srsly.read_gzip_json("/app/byaldi/lkpp-multimodal/index_config.json.gz")
index_config["model_name"] = "/tmp/colqwen2"
srsly.write_gzip_json("/app/byaldi/lkpp-multimodal/index_config.json.gz", index_config)


RAG = RAGMultiModalModel.from_index("/app/byaldi/lkpp-multimodal", index_root="")


def handler(job):
    job_input = job["input"]
    query = job_input["query"]

    results = RAG.search(query=query, k=5)

    response = [
        {
            "doc_id": r.doc_id,
            "page_num": r.page_num,
            "base64": r.base64,
            "score": r.score,
        }
        for r in results
    ]

    return response


runpod.serverless.start({"handler": handler})
