# %%
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from supabase import create_client, Client
from typing import Dict
import uvicorn
import base64
from openai import OpenAI
from dotenv import load_dotenv
import os
import json
import weaviate

load_dotenv()
client = OpenAI()

WEAVIATE_URL = os.getenv('WEAVIATE_URL')
if not WEAVIATE_URL:
    WEAVIATE_URL = 'http://localhost:8090'

weave_client = weaviate.Client(WEAVIATE_URL)

def encode_image(image_path):
  with open(image_path, "rb") as image_file:
    return base64.b64encode(image_file.read()).decode('utf-8')

def weaviate_img_search(img_str):
    """
    This function uses the nearImage operator in Weaviate. 
    """
    sourceImage = {"image": img_str}

    weaviate_results = weave_client.query.get(
        "Cat", ["identifier","breed","coat","age"]
        ).with_near_image(
            sourceImage, encode=False
        ).with_limit(2).do()

    print(weaviate_results)

    return weaviate_results["data"]["Get"]["Cat"]

# Replace with your Supabase project URL and API key
SUPABASE_URL = "http://localhost:8000"
SUPABASE_KEY = ""
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
security = HTTPBearer()


app = FastAPI()
origins = [
    "http://cat-egorize.sanguinare.dev:2050",
    "https://cat-egorize.sanguinare.dev:2050",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def verify_jwt(credentials: HTTPAuthorizationCredentials = Depends(security)) -> Dict:
    try:
        token = credentials.credentials
        payload = supabase.auth.get_user(token)
        return payload
    except Exception as e:
        print(e)
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/classify")
def classify_image(image_name: str, payload: Dict = Depends(verify_jwt)):
    try:
        user = payload.user
        with open(image_name, 'wb+') as f:
            res = supabase.storage.from_("newSightingPictures").download(image_name)
            supabase.storage.from_("sightingPictures").upload(file=res,path=f"{user.id}/{image_name}", file_options={"content-type": "image"})
            f.write(res)
        
        # Getting the base64 string
        base64_image = encode_image(image_name)
        os.remove(image_name)

        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {
                "role": "user",
                "content": [
                    {
                    "type": "text",
                    "text": "What breed of cat is in this image, what coat does it have, and how old do you think it is in years?",
                    },
                    {
                    "type": "image_url",
                    "image_url": {
                        "url":  f"data:image/jpeg;base64,{base64_image}"
                    },
                    },
                ],
                }
            ],
            response_format={
                "type": "json_schema",
                "json_schema": {
                    "name": "cat_data",
                    "schema": {
                        "type": "object",
                        "properties": {
                            "breed": {"type": "string"},
                            "coat_pattern": {"type": "string"},
                            "age": {"type": "int"}
                        },
                        "required": ["breed", "coat_pattern", "age"],
                        "additionalProperties": False
                    },
                    "strict": True
                }
            }
        )
            
        res = supabase.storage.from_('newSightingPictures').remove(image_name)
        cat_data = json.loads(response.choices[0].message.content)
        return cat_data
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid image data: {str(e)}")

@app.post("/associate")
def associate_cat(sighting_id: int, payload: Dict = Depends(verify_jwt)):
    try: 
        sighting = supabase.schema("public").table("sightings").select("*").eq("id", sighting_id).execute().data[0]
        image = supabase.schema("storage").table("objects").select("*").eq("id", sighting["image"]).execute().data[0]
        filename, file_extension = os.path.splitext(image['name'])
        destination = os.path.join(
            os.getcwd(), 
            f'{sighting["id"]}{file_extension}'
        )
        with open(destination, 'wb+') as f:
            res = supabase.storage.from_("sightingPictures").download(image['name'])
            f.write(res)
        encoded_img = encode_image(destination)
        os.remove(destination)
        weaviate_results = weaviate_img_search(encoded_img)
        return weaviate_results[0]
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Invalid data: {str(e)}")

@app.post("/login")
def login(email: str, password: str):
    try:
        response = supabase.auth.sign_in_with_password({"email": email, "password": password})
        return {"access_token": response.session.access_token}
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid credentials")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=2050)