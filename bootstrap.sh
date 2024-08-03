#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set your project ID and region
PROJECT_ID="my-ndf-terraform-proj"
REGION="australia-southeast1"

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

# Function to create or update a trigger
create_or_update_trigger() {
    local name=$1
    local branch=$2

    if gcloud builds triggers describe "$name" --project=$PROJECT_ID > /dev/null 2>&1; then
        echo "Trigger $name already exists. Updating..."
        gcloud builds triggers update github \
            --project=$PROJECT_ID \
            --name="$name" \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --build-config=cloudbuild.yaml \
            --description="Trigger for $branch branch" \
            --verbosity=debug
    else
        echo "Creating trigger $name"
        gcloud builds triggers create github \
            --project=$PROJECT_ID \
            --name="$name" \
            --repo-name=projectx-infra-core \
            --repo-owner=Gary-Li-LJH \
            --branch-pattern="^$branch$" \
            --build-config=cloudbuild.yaml \
            --description="Trigger for $branch branch" \
            --verbosity=debug
    fi
}

# Create or update triggers
create_or_update_trigger "dev-branch-trigger" "dev"
create_or_update_trigger "main-branch-trigger" "main"

echo "Setup complete. Cloud Build triggers have been created/updated."