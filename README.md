
# Rony-Advanced-Docker

This is the assignement for session 3 about advanced docker commands and docker compose, where minIO and a flask app were set up and ran inside a container using docker compose, along with the answers for the given questions in `questions.md`.

## docker-compose.yml new commands:

- `image`: Defines a base image that already exists to work with it. *Here it was used to pull the minio image*

- `volumes`: Connects a directory on the host or another container with the current container and share the data inside it. *Here we connected the minIO bucket with a directory on host in order to save and access uploaded contents even after container restart*.

- `networks`: Defines the network system used between containers. *Here we chose bridge which is the most isolated one*.

- `healthcheck`: Regularly checks the container health every interval specified. *For example here we check the health of the flask app every 30 seconds*.

## Usage:
1. Start by cloning the repository to your system.

2. Run the following command:
    ```terminal
    docker compose up --build
    ```

3. Open `add-file-here.html` in a browser and upload any file. All files will be saved and never lost even after restarting the container. *(You can also send JSON objects using curl)*
