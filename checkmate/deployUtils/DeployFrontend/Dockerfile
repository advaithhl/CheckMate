# Use the latest official Python image from Docker Hub
# This includes a base Linux system with Python pre-installed
FROM python:latest

# Set the working directory inside the container
# /usr/src will be the directory where the application files will be copied to and executed from
WORKDIR /usr/src

# Copy the Python application and its requirements file from the host to the container
# These files are placed in the /usr/src directory inside the container
COPY "main.py" "requirements.txt" /usr/src/

# Install the dependencies listed in the requirements.txt file
# This step runs pip inside the container and installs any packages needed by the application
RUN [ "python3", "-m", "pip", "install", "-r", "requirements.txt" ]

# Set the default command to run the Python application
# When the container starts, it will run main.py using Python
CMD [ "python3", "main.py" ]
