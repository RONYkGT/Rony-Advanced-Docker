from flask import Flask, request, jsonify
from minio import Minio
from minio.error import S3Error
import os
import io 

app = Flask(__name__)

minio_client = Minio(
    "minio:9000",
    access_key=os.getenv('MINIO_ACCESS_KEY'),
    secret_key=os.getenv('MINIO_SECRET_KEY'),
    secure=False
)

bucket_name = "mybucket"

@app.route('/store', methods=['POST'])

def store():
    # Accepts files and JSON uploads

    if request.files:
        # Handle files upload
        try:
            for key in request.files:
                # Go through all the key fields and upload them to avoid key error
                file = request.files[key]
                object_name = file.filename
                content_bytes = file.read()

                minio_client.put_object(bucket_name, object_name, io.BytesIO(content_bytes), len(content_bytes))

            return jsonify({"message": "File stored successfully"}), 200
        except KeyError:
            return jsonify({"error": "No file part in the request"}), 400
        except S3Error as e:
            return jsonify({"error": str(e)}), 500
        
    # ---
    
    elif request.json:
        # Handle JSON data
        data = request.json
        object_name = data.get("name")
        content = data.get("content")

        try:
            # Convert content to bytes-like object
            content_bytes = content.encode('utf-8')

            minio_client.put_object(bucket_name, object_name, io.BytesIO(content_bytes), len(content_bytes))

            return jsonify({"message": "Data stored successfully"}), 200
        except S3Error as e:
            return jsonify({"error": str(e)}), 500
    else:
        return jsonify({"error": "Unsupported request format. Expected JSON or file upload."}), 400


if __name__ == "__main__":
    if not minio_client.bucket_exists(bucket_name):
        minio_client.make_bucket(bucket_name)
    app.run(host='0.0.0.0', port=5000)