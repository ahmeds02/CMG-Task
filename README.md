# CMG-Task

Bash Script for processing the log files and automate the quality control evaluation.

This Bash script reads temperature and humidity data from a file and performs analysis to determine the precision of the readings. The script also includes a Dockerfile for building a container image that runs the script.

Usage
To use the Bash script, run the following command:

bash
./temperature_analysis.sh readings.txt

where readings.txt is the name of the file containing the temperature and humidity readings. The script will output the precision of each thermometer and whether to keep or discard each humidity reading.

Docker Usage
To build a Docker image that runs the temperature analysis script, run the following command:

docker build -t temperature-analysis .
To run the Docker container, execute the following command:

ruby
Copy code
docker run -v <path-to-readings-file>:/app/readings.txt temperature-analysis
Replace `<path-to-readings-file> with the local path to thereadings.txt` file.

Files:

temperature_analysis.sh: Bash script for analyzing temperature and humidity readings.

Dockerfile: Dockerfile for building a container image that runs the temperature analysis script.

deployment.yaml: Kubernetes deployment configuration for deploying the temperature analysis container.

service.yaml: Kubernetes service configuration for exposing the temperature analysis container.

hpa.yaml: Kubernetes Horizontal Pod Autoscaler configuration for scaling the temperature analysis deployment based on CPU utilization.

Kubernetes Deployment

The Kubernetes deployment, service, and HPA configurations are included in the deployment.yaml, service.yaml, and hpa.yaml files, respectively. 

The deployment and service files can be applied to a Kubernetes cluster using the following commands:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

The HPA can be applied to the cluster using the following command:

kubectl apply -f hpa.yaml

The HPA configuration will scale the temperature analysis deployment based on CPU utilization, with a minimum of 2 and maximum of 5 replicas.

Notes

The Bash script assumes that the input file is in the format specified in the project requirements. If the input file format changes, the script will need to be modified accordingly.

The Dockerfile uses a Python base image, but the Bash script can be run without Python. A more lightweight base image could be used if desired.

The Kubernetes deployment, service, and HPA configurations are for reference only and may need to be modified based on the specific needs of your environment.
