#Terminate service and free up resource
# reading variables
. .\variables.ps1
#Delete FWD rule
gcloud compute forwarding-rules delete cnlb-forwarding-rule --global

#delete proxy
gcloud compute target-http-proxies delete cnlb-target-proxy

#Delete URL map
gcloud compute url-maps delete cnlb

#Delete backend bucket
gcloud compute backend-buckets delete resume-backend

#Delete bucket
gcloud storage rm -r gs://$bucket_name --project=$project
gcloud storage buckets delete gs://$bucket_name --project=$project