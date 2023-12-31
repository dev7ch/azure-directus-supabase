﻿# Directus CI/CD Azure + Supabase

Multistage CI/CD for free tier cloud hosting with persistent data.

## Introduction

Directus hosted on Azure App Service using Supabase for database and file storage.
Multistage CI/CD Pipeline with GitHub Actions and automated provisioning of Azure resources by running manual workflow actions (or by tagging a pull request).
This setup is working completely on free tiers. Consider to use the Directus Cloud for production to support the awesome Directus team.

## Prerequisites

- An Azure portal account
- A GitHub account
- A Supabase account
- Azure CLI installed

## Preparation

1. Create Azure service principal

```
az login  
az ad sp create-for-rbac --name "GitHub-Actions" --role contributor --scopes /subscriptions/<Your-Azure-Subscription-ID> --sdk-auth
```
2. Clone or fork this repo to your own GitHub
3. Add result of 1. as `AZURE_CREDENTIALS` to GitHub Actions Secrets
4. Add `AZURE_SUBSCRIPTION_ID` filled with `<Your-Azure-Subscription-ID>` to GitHub Actions Secrets 
5. Goto Supabase and create a project with a storage bucket
6. Copy `.env.dist` to `.env.prev` and `.env.prod` and provide your own values for each environment
7. Add `CONFIG_PREV_ENV` with content of `.env.prev` and `CONFIG_PROD_ENV` with content of `.env.prod` to Github Actions Secrets 
8. Create a Personal Access Token in Developer settings with permissions `repo`, `write:packages`, `delete:packages` to give Azure app service access to your private image registry
9. Add the token from 8. as `REGISTRY_PASSWORD` to GitHub Actions Secrets

## Deployment

Initially, use the manual GitHub action named `Spin up Azure environment` to spin up all resources once.
This example uses the branches `prod` and `prev` for automated deployments on push.

After resource group is already created use the manual GitHub action `Spin up Azure web app only` to add a new stage for a new branch

The rest of the workflows are supposed to be self explaining so far.

## Security

**Make sure your GitHub packages are private**, this approach stores the `.env` file in the docker image.
Considering using the Azure Vault or set env vars at Azure web app settings if you`d like to scale this setup to production.

Note that port 25 is blocked on Azure App Service when you set up smtp settings.

## Development

- Check out the [Supabase Docs for running locally](https://supabase.com/docs/guides/cli/local-development) and get it running locally
- Prepare your local `.env` file and install dependencies
```
cp .env.dist .env
npm i
```
- Start directus instance
```
npm run start
```

Keep enjoying the wonderful Directus!

