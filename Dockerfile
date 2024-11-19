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
