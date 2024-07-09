# Using alpine for smaller size python base
FROM python:3.8-alpine AS build 

# Install the required C compiler to fix install error in requirements.txt
RUN apk add --no-cache gcc musl-dev libffi-dev


# Focus on the requirements first and finish installing them
# so that we don't have to reinstall them if the requirements don't change in case
# of code editing

WORKDIR /app
COPY ./api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# The final build, will only get the installed dependencies,
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
