#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set your project ID and region
PROJECT_ID="my-ndf-terraform-proj"
REGION="australia-southeast1"

# Function to check if a service is already enabled
is_service_enabled() {
    gcloud services list --enabled --filter="NAME:$1" --format="value(NAME)" | grep -q "$1"
}

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
    if ! is_service_enabled "$api"; then
        echo "Enabling $api"
        gcloud services enable "$api" --project $PROJECT_ID
    else
        echo "$api is already enabled"
    fi
done

# Create Terraform state bucket if it doesn't exist
BUCKET_NAME="${PROJECT_ID}-terraform-state"
if ! gsutil ls -b gs://$BUCKET_NAME > /dev/null 2>&1; then
    echo "Creating bucket $BUCKET_NAME"
    gsutil mb -p $PROJECT_ID -l $REGION gs://$BUCKET_NAME
    gsutil versioning set on gs://$BUCKET_NAME
else
    echo "Bucket $BUCKET_NAME already exists"
fi

# Connect your GitHub repository to Cloud Build (this will fail if already connected, which is fine)
gcloud beta builds repos connect \
    --project=$PROJECT_ID \
    --repository=projectx-infra-core \
    --host-uri=https://github.com \
    --region=$REGION || true

# Read the Cloud Build configuration from file
CLOUDBUILD_CONFIG=$(cat cloudbuild.yaml)

# Function to create or update a trigger
create_or_update_trigger() {
    local name=$1
    local branch=$2
    if gcloud builds triggers describe "$name" --project=$PROJECT_ID > /dev/null 2>&1; then
        echo "Updating trigger $name"
        gcloud builds triggers update "$name" \
            --project=$PROJECT_ID \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --inline-config="$CLOUDBUILD_CONFIG"
    else
        echo "Creating trigger $name"
        gcloud builds triggers create github \
            --project=$PROJECT_ID \
            --name="$name" \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --inline-config="$CLOUDBUILD_CONFIG"
    fi
}

# Create or update triggers
create_or_update_trigger "dev-branch-trigger" "dev"
create_or_update_trigger "main-branch-trigger" "main"

echo "Setup complete. Remember to install the Google Cloud Build GitHub app in your repository if you haven't already."
echo "Go to your GitHub repository > Settings > Integrations > Applications"
echo "Find 'Google Cloud Build' and install it for your repository"