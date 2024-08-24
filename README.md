# Terraform Infrastructure Setup for Redirecting Custom Domain to Google Docs Resume

<div align="center">

  <img src="images/public-resume.png" alt="flowchart">

</div>

## Overview

This repository provides a Terraform setup to redirect a custom domain to a Google Docs resume using AWS services. The solution involves configuring AWS CloudFront, Route 53, and S3 to handle redirection with Terraform automation.

## Architecture

The infrastructure consists of:

- **Route 53:** Resolves the custom domain to the CloudFront distribution.
- **CloudFront Distribution:** Manages the HTTPS connection and runs a CloudFront Function to issue the redirect.
- **S3 Bucket:** Acts as a minimal origin required by CloudFront, though no content is served from it.
- **CloudFront Function:** Redirects requests to the Google Docs resume link.

## Prerequisites

Before getting started, ensure you have:

- A registered custom domain (with AWS Route 53 or another registrar).
- A public Route 53 hosted zone set up in your AWS account.
- A publicly shareable Google Docs resume link.
- Terraform installed on your local machine.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

## Configure Your Variables

1. **Edit `terraform.tfvars`**

   Update the `terraform.tfvars` file with your domain information:

   - `root_domain`: Your main domain (e.g., `your-custom-domain.com`).
   - `resume_domain`: The subdomain for your resume (e.g., `resume.your-custom-domain.com`).

2. **Update `redirectToExternalSite.js`**

   Modify the `redirectToExternalSite.js` file to include the URL of your Google Docs resume. Locate the `google_form_url` variable and set it to your resume's public link:

## Run the Deployment

Execute the following script to initialize and apply the Terraform configuration:

```bash
chmod +x ./infrastructure/deploy.sh
./infrastructure/deploy.sh
```

This script will:

- Initialize Terraform.
- Apply the configuration to set up the necessary AWS resources.

## Learn More on Medium

I’ve written a detailed tutorial on how to set up AWS CloudFront, S3, and Route 53 to redirect a custom domain to a Google Docs resume using Terraform. This post covers the step-by-step process, including configuration and deployment.

[Read the Full Tutorial on Medium](https://awstip.com/effortlessly-redirect-your-custom-domain-to-a-google-docs-resume-using-aws-a-terraform-guide-93f5cde92e40?source=friends_link&sk=64c7ae560790b8ddd58edcb1676f0410)

Feel free to check it out for more in-depth information and insights!
