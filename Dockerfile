# Using alpine for smaller size python base
FROM python:3.8-alpine AS build 

# Install the required C compiler to fix install error of cffi during setup
RUN apk add --no-cache gcc musl-dev libffi-dev


# Focus on installing the requirements first
# so that we don't have to reinstall them if the requirements are still the same
# in case of editing app.py

WORKDIR /app
COPY ./api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# The final build, will only get the installed dependencies from last build,
# and will get rid of requirements.txt
# and all the intermediary files used to install the dependencies 
FROM python:3.8-alpine 

WORKDIR /app

# Copies the installed dependencies from the initial build image
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

# Copy the remaining file into the working dir (/app)
COPY ./api/app.py .

EXPOSE 5000

CMD ["python3","./app.py"]
