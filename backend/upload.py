import os, re
import weaviate

WEAVIATE_URL = os.getenv('WEAVIATE_URL')
if not WEAVIATE_URL:
    WEAVIATE_URL = 'http://localhost:8090'

def set_up_batch():
    """
    Prepare batching configuration to speed up deleting and importing data.
    """
    client.batch.configure(
        batch_size=100, 
        dynamic=True,
        timeout_retries=3,
        callback=None,
    )
    
def clear_up_cats():
    """
    Remove all objects from the Cats collection.
    This is useful, if we want to rerun the import with different pictures.
    """
    with client.batch as batch:
        batch.delete_objects(
            class_name="Cat",
            # same where operator as in the GraphQL API
            where={
                "operator": "NotEqual",
                "path": ["breed"],
                "valueString": "x"
            },
            output="verbose",
        )

def import_data():
    """
    Process all images in [base64_images] folder and add import them into Cats collection
    """

    with client.batch as batch:
        # Iterate over all .b64 files in the base64_images folder
        for encoded_file_path in os.listdir("./base64_images"):
            with open("./base64_images/" + encoded_file_path) as file:
                file_lines = file.readlines()

            base64_encoding = " ".join(file_lines)
            base64_encoding = base64_encoding.replace("\n", "").replace(" ", "") 

            # remove .b64 to get the original file name
            image_file = encoded_file_path.replace(".b64", "")

            # remove image file extension and swap - for " " to get the breed name
            file_disassembled = image_file.split("-")

            db_id, file_ext = os.path.splitext(file_disassembled[3])

            # The properties from our schema
            data_properties = {
                "breed": file_disassembled[0],
                "coat": file_disassembled[1],
                "age": file_disassembled[2],
                "identifier": db_id,
                "image": base64_encoding,
            }

            res = batch.add_data_object(data_properties, "Cat")
            print(res)

client = weaviate.Client(WEAVIATE_URL)
set_up_batch()
clear_up_cats()
import_data()

print("The objects have been uploaded to Weaviate.")