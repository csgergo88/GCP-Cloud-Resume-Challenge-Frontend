# Cloud resume Challange Frontend

<p align="center">
  <a href="">
    <img src="https://miro.medium.com/v2/resize:fit:720/format:webp/1*lDi1bp7b37khnH3tPVoLuQ.png" alt="Logo" width="50%" height="50%">
  </a>

  <h3 align="center">Google Cloud Platform (GCP) Resume Challenge </h3>

  <p align="center">
    Build a serverless resume website on GCP with API backend and GitOps-based CI/CD
    <br />
    <a href="https://acloudguru.com/blog/engineering/cloudguruchallenge-your-resume-on-gcp" target="_blank"><strong>See challenge description by Mattias Andersson @CloudGuru »</strong></a>
    <br />
    <br />
    <a href="https://github.com/alfonsmr/GCP-Cloud-Resume-Challenge-Frontend/issues">Report Bug</a>
    ·
    <a href="https://github.com/alfonsmr/GCP-Cloud-Resume-Challenge-Frontend/issues">Request Feature</a>
  </p>
</p>

This repository contains the frontend code for the Cloud Resume Challenge. The deployment process is streamlined using the deployment.ps1 script, allowing for easy deployment of the frontend to Google Cloud Platform (GCP). This README provides guidance on using the deployment script and deploying the frontend to GCP.

## Prerequisites
Before using the deployment script, ensure you have the following prerequisites:

- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install) installed and configured.
- GCP project created and configured.
- PowerShell environment for running the deployment script.
- Terraform (optional)

## Usage

1. Clone the repository:
   ```
   git clone https://github.com/your-username/cloud-resume-frontend.git
   cd cloud-resume-frontend

Ensure that your variables.ps1 file is correctly configured with your GCP project, Cloud Run service URL, and preferred region:

```
   $region = "us-east1"
   $project = "resumechallangetest"
   $cloudrunserviceurl = "https://test-h5jqdffluq-ue.a.run.app"
   $bucket_name = "resume_challange"
```
Run the deployment script:

```
   .\deployment.ps1
```
Wait for the deployment process to complete. This includes creating a storage bucket, updating the resume HTML with the Cloud Run service URL, granting access to all users, and setting up a CDN and Load Balancer.

After the deployment is successful, you can access your Cloud Resume frontend using the Load Balancer IP provided in the script output.

## Notes
Ensure that the variables.ps1 file is correctly configured with your GCP project, Cloud Run service URL, and preferred region before running the script.
The script creates a storage bucket, updates the HTML with the Cloud Run service URL, and sets up a CDN and Load Balancer to serve the frontend.
Feel free to customize the script or HTML file according to your specific requirements. For any issues or improvements, please open an issue or pull request on the repository.

## Update
You can now optionally use init.tf to create resources by using terrafrom. Please don't forget to create a service account with the neccesary roles and put credentials of this service account to credentials.json. 
You'll need to update variables on the top of the file such as project, region, etc. 
Deploy resources:

```
   terraform .\init.tf
```

Happy coding!
