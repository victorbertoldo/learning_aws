#!/bin/bash -ex

# Update the system
sudo yum update -y

# Install Development Tools and necessary libraries
sudo yum groupinstall "Development Tools" -y
sudo yum install bzip2-devel libffi-devel xz-devel -y

# Install EPEL repository and additional tools
sudo amazon-linux-extras install epel -y
sudo yum install -y wget unzip

# Check for the latest version of OpenSSL and install it
sudo yum install openssl-devel -y

# Download and install Python 3.10.4
wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tar.xz
tar -xf Python-3.10.4.tar.xz
cd Python-3.10.4
./configure --enable-optimizations
make
sudo make altinstall  # Use altinstall to avoid overwriting the default python3 binary
cd ..

# Verify Python 3.10.4 installation
/usr/local/bin/python3.10 --version

# Ensure pip is upgraded for Python 3.10.4
/usr/local/bin/python3.10 -m ensurepip --upgrade

# Download the Flask application
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
sed -i 's/TextField/StringField/g' FlaskApp/application.py

# Navigate into the Flask application directory
cd FlaskApp/

# Install application dependencies using Python 3.10.4's pip
/usr/local/bin/pip3.10 install -r requirements.txt

# Optional: Install a specific version of urllib3 if required by the application
/usr/local/bin/pip3.10 install urllib3==1.26.6

# Set necessary environment variables for the Flask application
export PHOTOS_BUCKET=${SUB_PHOTOS_BUCKET}  # Replace ${SUB_PHOTOS_BUCKET} with your actual bucket name
export AWS_DEFAULT_REGION=us-west-2
export DYNAMO_MODE=on

# Run the Flask application with Python 3.10.4
# Setting FLASK_APP environment variable and running the Flask development server
export FLASK_APP=application.py
/usr/local/bin/python3.10 -m flask run --host=0.0.0.0 --port=80
