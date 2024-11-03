import os
import weaviate

WEAVIATE_URL = os.getenv('WEAVIATE_URL')  
if not WEAVIATE_URL:
    WEAVIATE_URL = 'http://localhost:8090'

print(WEAVIATE_URL, flush=True)
# TODO: Port to weaviate
client = weaviate.Client(WEAVIATE_URL)

# creating the Cat class with the following properties: breed, coat image, and filepath

schema = {
    "classes": [
        {
            "class": "Cat",
            "description": "Images of different cats",
            "moduleConfig": {
                "img2vec-neural": {
                    "imageFields": [
                        "image"
                    ]
                }
            },
            "vectorIndexType": "hnsw", 
            "vectorizer": "img2vec-neural", # the img2vec-neural Weaviate module
            "properties": [
                {
                    "name": "breed",
                    "dataType": ["string"],
                    "description": "name of cat breed",
                },
                {
                    "name": "coat",
                    "dataType": ["string"],
                    "description": "name of cat coat pattern",
                },
                {
                    "name": "image",
                    "dataType": ["blob"],
                    "description": "image",
                },
                {
                    "name": "identifier",
                    "dataType":["string"],
                    "description": "identifier of the images",
                }
            ]
        }
    ]
}

# adding the schema 
client.schema.create(schema)

print("The schema has been defined.")