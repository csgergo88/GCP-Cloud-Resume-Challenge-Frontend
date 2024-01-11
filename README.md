# GCP-Cloud-Resume-Challenge-Frontend
This repository contains the frontend code for the Cloud Resume Challenge. The deployment process is streamlined using the deployment.ps1 script, allowing for easy deployment of the frontend to Google Cloud Platform (GCP). This README provides guidance on using the deployment script and deploying the frontend to GCP.

Prerequisites
Before using the deployment script, ensure you have the following prerequisites:

Google Cloud SDK (gcloud) installed and configured.
GCP project created and configured.
PowerShell environment for running the deployment script.
Usage
Clone the repository:

bash
Copy code
git clone https://github.com/your-username/cloud-resume-frontend.git
cd cloud-resume-frontend
Create a variables.ps1 file and set the necessary variables:

powershell
Copy code
$project = "your-gcp-project"
$bucket_name = "your-unique-bucket-name"
$region = "your-preferred-region"
Run the deployment script:

powershell
Copy code
.\deployment.ps1
Wait for the deployment process to complete. This includes creating a storage bucket, updating the resume HTML with the Cloud Run service URL, granting access to all users, and setting up a CDN and Load Balancer.

After the deployment is successful, you can access your Cloud Resume frontend using the Load Balancer IP provided in the script output.

Notes
Ensure that the variables.ps1 file is correctly configured with your GCP project, bucket name, and preferred region before running the script.
The script creates a storage bucket, updates the HTML with the Cloud Run service URL, and sets up a CDN and Load Balancer to serve the frontend.
Feel free to customize the script or HTML file according to your specific requirements. For any issues or improvements, please open an issue or pull request on the repository.

Happy coding!






