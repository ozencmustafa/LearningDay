# Learning Day

To use Flask in your Python web server and include it in a requirements.txt file, follow these steps:

## Create requirements.txt
Create a file named requirements.txt in the same directory as your Python script with the following content:

```
flask==2.3.3
```
This specifies the Flask library and its version. Adjust the version if needed.


## Create Dockerfile

Create a Dockerfile in the same directory as your Python web server script (e.g., server.py)
```
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies if required (comment out if not needed)
RUN pip install -r requirements.txt

# Expose port 5000 for the webserver
EXPOSE 5000

# Define environment variable (optional, adjust based on your script)
ENV FLASK_APP server.py

# Run the web server
CMD ["python", "server.py"]

```

## Flask-Based server.py
```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)


```

 ## Build and Run the Docker Image
Build the image.
```
docker build -t flask-hello-world .
```

Run the container:
```
docker run -p 5000:5000 flask-hello-world
```

Access the app at http://localhost:5000.

