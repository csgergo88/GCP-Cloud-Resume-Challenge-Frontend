#This script was created to deploy Cloud Run resources in your GCP project
# reading variables
. .\variables.ps1

#initialization
#gcloud init
gcloud config set project $project

#init variables.py


#Create bucket
gcloud storage buckets create gs://$bucket_name --project=$project --default-storage-class=standard --location=$region --uniform-bucket-level-access

#Update CV with Cloud Run service URL
(Get-Content .\my_resume_blank.html).Replace('%CLOUD_RUN_SERVICE_URL', $cloudrunserviceurl) | Set-Content .\my_resume.html

#Update policy and give access to all user
gcloud storage buckets update gs://$bucket_name --no-public-access-prevention
gsutil iam ch allUsers:objectViewer gs://$bucket_name

#Upload HTML to bucket
gsutil cp .\my_resume.html gs://$bucket_name

#Create CDN and LB

#Creating backend bucket
gcloud compute backend-buckets create resume-backend --gcs-bucket-name=$bucket_name --no-enable-cdn

#URL Map
gcloud compute url-maps create cnlb --default-backend-bucket=resume-backend 

#Creating target HTTP Proxy
gcloud compute target-http-proxies create cnlb-target-proxy --url-map=cnlb

#Creating FWD rule
gcloud compute forwarding-rules create cnlb-forwarding-rule --ip-version=IPV4 --load-balancing-scheme=EXTERNAL_MANAGED --network-tier=PREMIUM --ports=80 --global --target-http-proxy=cnlb-target-proxy

#you might need to wait few minutes to be able to contact your URL
#
#You can find the LB IP in following output
gcloud compute forwarding-rules describe cnlb-forwarding-rule --global



