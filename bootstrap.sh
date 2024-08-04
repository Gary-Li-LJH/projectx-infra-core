#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set your project ID and region
PROJECT_ID="my-ndf-terraform-proj"
REGION="australia-southeast1"
SERVICE_ACCOUNT_NAME="cloud-build-service-account"
SERVICE_ACCOUNT_EMAIL="cloud-build-service-account@${PROJECT_ID}.iam.gserviceaccount.com"

# Authenticate with gcloud (this will open a browser window)
gcloud auth login

# Set the project
gcloud config set project $PROJECT_ID

# Enable necessary APIs
apis=(
    "compute.googleapis.com"
    "storage-api.googleapis.com"
    "storage-component.googleapis.com"
    "bigquery.googleapis.com"
    "dataflow.googleapis.com"
    "cloudbuild.googleapis.com"
    "cloudresourcemanager.googleapis.com"
    "iam.googleapis.com"
    "composer.googleapis.com"
    "dataform.googleapis.com"
)

for api in "${apis[@]}"; do
    if gcloud services list --enabled --format="value(NAME)" | grep -q "$api"; then
        echo "$api is already enabled"
    else
        echo "Enabling $api"
        gcloud services enable "$api" --project $PROJECT_ID
    fi
done

# Check if Terraform state bucket exists, create if it doesn't
BUCKET_NAME="${PROJECT_ID}-terraform-state"
if gsutil ls -b gs://$BUCKET_NAME > /dev/null 2>&1; then
    echo "Bucket $BUCKET_NAME already exists"
else
    echo "Creating bucket $BUCKET_NAME"
    gsutil mb -p $PROJECT_ID -l $REGION gs://$BUCKET_NAME
fi

# Enable versioning on the bucket (this is idempotent, so we can run it every time)
gsutil versioning set on gs://$BUCKET_NAME

# Create a service account for Cloud Build if it doesn't exist
if gcloud iam service-accounts describe $SERVICE_ACCOUNT_EMAIL --project=$PROJECT_ID > /dev/null 2>&1; then
    echo "Service account $SERVICE_ACCOUNT_EMAIL already exists"
else
    echo "Creating service account $SERVICE_ACCOUNT_EMAIL"
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
        --display-name="Cloud Build Service Account" \
        --project=$PROJECT_ID
fi

# Grant necessary roles to the service account
roles=(
    "roles/cloudbuild.builds.builder"
    "roles/storage.objectViewer"
    "roles/storage.admin"
    # Add any other necessary roles here
)

for role in "${roles[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
        --role="$role"
done

# Function to create or update a trigger

create_or_update_trigger() {
    local name=$1
    local branch=$2

    # Check if trigger exists
    if gcloud builds triggers describe "$name" --project=$PROJECT_ID --region=$REGION &>/dev/null; then
        echo "Trigger $name already exists. Updating..."
        gcloud beta builds triggers update github "$name" \
            --project=$PROJECT_ID \
            --region=$REGION \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --build-config=cloudbuild.yaml \
            --service-account="projects/$PROJECT_ID/serviceAccounts/$SERVICE_ACCOUNT_EMAIL"
    else
        echo "Creating trigger $name"
        gcloud beta builds triggers create github \
            --project=$PROJECT_ID \
            --region=$REGION \
            --name="$name" \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --build-config=cloudbuild.yaml \
            --service-account="projects/$PROJECT_ID/serviceAccounts/$SERVICE_ACCOUNT_EMAIL"
    fi
}


# Create or update triggers
create_or_update_trigger "dev-branch-trigger" "dev"
create_or_update_trigger "main-branch-trigger" "main"

echo "Setup complete. Cloud Build triggers have been created/updated with a dedicated service account."
