import runpod

import srsly
from byaldi import RAGMultiModalModel

index_config = srsly.read_gzip_json("..byaldi/lkpp-multimodal/index_config.json.gz")
index_config["model_name"] = "/tmp/model"

srsly.write_gzip_json("..byaldi/lkpp-multimodal/index_config.json.gz", index_config)

RAG = RAGMultiModalModel.from_index("../byaldi/lkpp-multimodal")


def handler(job):
    job_input = job["input"]
    query = job_input["query"]

    results = RAG.search(query=query, k=5)

    return results


runpod.serverless.start({"handler": handler})
