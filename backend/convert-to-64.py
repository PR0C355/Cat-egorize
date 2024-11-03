import os 
import shutil
from supabase import create_client, Client


SUPABASE_URL = "http://localhost:8000"
SUPABASE_KEY = ""
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def clear_base64_images():
    
    base_folder = os.path.join(os.getcwd(), "base64_images")

    # if the base64_images folder => delete it 
    if os.path.exists(base_folder):
        shutil.rmtree(base_folder)
    
    # create the base64_images folder
    os.mkdir(base_folder)  

def clear_downloaded_images():
    base_folder = os.path.join(os.getcwd(), "images")

    # if the images folder => delete it 
    if os.path.exists(base_folder):
        shutil.rmtree(base_folder)
    
    # create the images folder
    os.mkdir(base_folder) 

def download_images():
    for sighting in supabase.schema("public").table("sightings").select("*").execute().data:
        image = supabase.schema("storage").table("objects").select("*").eq("id", sighting["image"]).execute().data[0]
        filename, file_extension = os.path.splitext(image['name'])
        destination = os.path.join(
            os.getcwd(), 
            "images", 
            f'{sighting["predictedBreed"].replace(" ", "_")}-{sighting["predictedCoat"].replace(" ", "_")}-{sighting["estimatedAge"]}-{sighting["id"]}{file_extension}'
        )
        print(destination)
            # os.makedirs(destination)
        with open(destination, 'wb+') as f:
            res = supabase.storage.from_("sightingPictures").download(image['name'])
            f.write(res)

def convert_images_to_base64():
    img_path = "./images/"

    for file_path in os.listdir(img_path): # grabbing the images in the images folder and converting them to base64
        if ".DS_Store" not in file_path:
            filename = file_path.split("/")[-1]
            os.system("cat " + img_path + file_path + " | base64 > base64_images/" + filename + ".b64")

clear_base64_images()
clear_downloaded_images()
download_images()
convert_images_to_base64()

print("The images have been converted to base64.")