# CheckMate

A simple task planning app.

CheckMate has been built for three reasons:

1. 🎓 To score bonus points in the "Cloud Computing" course in the "Global Software Development" program at Hochschule Fulda.
2. ☁️ To see how one can build a truly serverless app.
3. 🎉 To have some fun in the clouds! 😉

## ✨ Features

CheckMate doesn't have many features at the moment; it's just a simple CRUD app. Most of the actual features are technical and will be detailed below. However, from a business perspective, these are the features of CheckMate:

- 🔐 Provides clean user login and registration pages.
- ✅ Offers a simple checklist page.
- 📅 Allows chronological sorting of tasks.
- ➕ Enables adding and deleting tasks.
- 🌙 Supports dark mode (inherits system theme).
- 🌍 Works across all browsers and form factors.

## 🔧 Technical features

Aah yes, the good stuff.

CheckMate is **completely serverless**! It will scale as long as there are resources in AWS 😉.

### 🛠️ Infrastructure

- **AWS Amplify Gen 2:** A serverless frontend hosting solution.
- **AWS API Gateway:** A proxy to direct traffic to appropriate functions.
- **AWS Lambda:** A serverless function for each route.
- **AWS DynamoDB:** A serverless NoSQL database.
- **AWS App Auto Scaling:** A scaling solution for different AWS resources.

### 📚 Libraries

- **React:** A component-based frontend library.
- **RadixUI:** A UI component library.
- **Vite:** A dev server and build tool that produces highly optimized static assets.
- **React Router:** A library that allow client-side routing.
- **Axios:** A library to issue HTTP requests to the backend.
- **Tanstack Query:** A library to asynchronously manage client-server state.
- **boto3**: An official python library for AWS (used for specific cases).

### 🚀 DevOps tools

- **Docker Compose:** A tool for running multiple containers with different parameters.
- **Terraform:** A tool for creating, managing, and destroying infrastructure through declarative code.

### 🔗 How it all ties together

- **Docker Compose** creates zip files with python dependencies suitable for deployment to **AWS Lambda**, in an environment similar to Lambda's python runtime. This is needed for specific cryptographic dependencies (like `bcrypt`).

- **Terraform** creates all AWS infrastructure namely a bare **AWS Amplify Gen 2** application with custom rewrite rules to enable client-side routing, **AWS API Gateway**, its routes and CORS configuration, five **AWS Lambda**s running the zip files created by **Docker Compose** for each route, **AWS DynamoDB** tables to store app data, **AWS App Auto Scaling** policies, and all the required IAM roles with fine-grained permissions.

- **React** uses **React Router**'s client-side routing to determine and load components made using **RadixUI**.

- The components rely on data/state provided by **Tanstack Query**, which in turn uses **Axios** to make HTTP requests to the **AWS API Gateway**.

- **Vite** bundles all of these together and hardcodes the URL of the **AWS API Gateway** provided in a **dotenv** format during build time and creates a folder containing a highly optimized bundle of static assets. This is done inside a `node` container which uses Docker volumes to share files between itself and the host system.

- Finally, **boto3** is used to zip the folder and deploy it to **AWS Amplify Gen 2**. This is done inside a `python` container, which again uses Docker volumes to bind host file system to that of the container's.

As of now, the official AWS Terraform module does **not** support zip deployments to **AWS Amplify** and an [issue](https://github.com/hashicorp/terraform-provider-aws/issues/24720) is open in Github for this. However, since the feature is supported by the REST API, **boto3** also supports this. This is one of the reasons why **boto3** was needed to place the deployment.

## 🚀 How to deploy CheckMate

You would need the following tools installed on your system:

- Docker Compose
- Terraform
- (Preferably, a UNIX shell)

### 🛠️ Step 1: Build Lambda deployment zip

To build your Lambda deployment zip, perform the following steps:

``` bash
cd checkmate
docker compose -f docker-compose.lambda_zip.yml up
```

This runs 5 containers of the same image based on `python3.12`. Docker Compose binds the directories containing the Lambda code to the working directories of the appropriate containers. The containers run the `docker-entrypoint.sh` script when executed and it installs `zip`, the custom `requirements.txt` for each Lambda function, and zips it according to the [AWS Documentation](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-create-dependencies).

The containers stop when the zip is built. To remove exited containers, do the following command to avoid creating orphan containers.

``` bash
docker compose -f docker-compose.lambda_zip.yml down
```

### 🧑‍💻 Step 2: Determine device architecture

Since CheckMate contains dependencies like `bcrypt`, it is highly dependent on the architecture of the machine it runs on. Lambda supports `arm64` and `x86_64` instruction set architectures. Determine the architecture of your machine (`arm64` or `x86_64`) where you ran step 1, before continuing to step 3.

### 🔑 Step 3: Provide AWS credentials as environment variables

Provide the AWS credentials, namely `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and optionally `AWS_SESSION_TOKEN` of an IAM user with administrator privileges, as environment variables.

macOS and Linux:

``` bash
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
export AWS_REGION=<YOUR_AWS_REGION>
export AWS_SESSION_TOKEN=<YOUR_AWS_SESSION_TOKEN> # Optional
```

*Note: If you need to use `sudo` to run docker, you can use `sudo bash` to open a root shell and run commands there. This way, the environment variables will be exported directly to the root shell and will be passed on to the containers by Docker Compose. Alternatively, you can add these variables to your shell profile (`.bashrc`, `.zshrc` etc.) and `source` the profile.*

Windows:

``` bat
SET AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
SET AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
SET AWS_REGION=<YOUR_AWS_REGION>
SET AWS_SESSION_TOKEN=<YOUR_AWS_SESSION_TOKEN>  REM Optional
```

Powershell:

``` Powershell
$Env:AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
$Env:AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
$Env:AWS_REGION=<YOUR_AWS_REGION>
$Env:AWS_SESSION_TOKEN=<YOUR_AWS_SESSION_TOKEN> # Optional
```

### 📐 Step 4: Use Terraform to create infrastructure

Navigate to the `infra` directory.

``` bash
cd infra
```

If your machine architecture is `arm64`, run the below command:

``` bash
terraform plan -out planfile -var 'lambda_architecture=["arm64"]'
```

If your machine architecture is `x86_64`, run the below command:

``` bash
terraform plan -out planfile -var 'lambda_architecture=["x86_64"]'
```

The command creates a speculative plan and saves the plan to a file. Use the `apply` command to create the infrastructure.

``` bash
terraform apply planfile
```

You will receive 3 outputs namely `amplify_app_id`, `checkmate_backend_url`, `checkmate_url`.

### 📝 Step 5: Provide backend URL as .env and Amplify app ID as environment variable

Navigate to the `frontend` directory.

``` bash
cd ..
cd frontend
```

Uncomment line #2 of the `.env` file and replace `API_GATEWAY_URL_HERE` to the value of `checkmate_backend_url` obtained in step 4. This is needed because the frontend build tool (Vite) uses dotenv and hardcodes this value in the production bundle during build.

Additionally, provide the value of `amplify_app_id` as an environment variable with the name `AMPLIFY_APP_ID`. This is needed for `boto3` to correctly identify the Amplify app on which it should deploy the built frontend code.

### 📦 Step 6: Deploy the frontend and obtain the URL to access CheckMate

Navigate one step back to the `checkmate` directory.

``` bash
cd ..
```

Run the below command to build and deploy the frontend of CheckMate.

``` bash
docker compose -f docker-compose.frontend.yml up
```

This launches two containers, both mounted to appropriate locations of the filesystem. The first container, based on a `node` image, runs `npm run build` to build the frontend. The second container, based on a `python` image, waits for a `dist/index.html` file to be created and once it's there, it zips the dist folder according to Amplify guidelines and deploys it to the Amplify app corresponding to `AMPLIFY_APP_ID`.

The containers stop when the frontend is built and deployed respectively. Just like before, to remove these containers, run the following command:

``` bash
docker compose -f docker-compose.frontend.yml down
```

Hurray! 🎉 You have deployed CheckMate! You will have received the link for the deployed CheckMate app. This is of the form `https://prod.{amplify_app_id}.amplifyapp.com`.

### 🧹 Step 7: Cleanup (Optional)

To cleanup the infrastructure created using terraform, you can use the destroy command from the `infra` directory:

``` bash
terraform destroy
```

By default, any logs (or more specifically, log groups) created by Lambdas will **not** be deleted automatically. This is for security and auditing purposes. You can delete the following AWS CloudWatch Log Groups created by CheckMate Lambda functions:

``` text
/aws/lambda/actionsAddItem
/aws/lambda/actionsDeleteItem
/aws/lambda/actionsGetItems
/aws/lambda/authLogin
/aws/lambda/authRegister
```

If you would like, you can also delete the Lambda deployment zips (run from the `checkmate` directory)...

``` bash
rm backend/actionsAddItem/my_deployment_package.zip
rm backend/actionsDeleteItem/my_deployment_package.zip
rm backend/actionsGetItems/my_deployment_package.zip
rm backend/authLogin/my_deployment_package.zip
rm backend/authRegister/my_deployment_package.zip
```

...and the built frontend (also run from the `checkmate` directory).

``` bash
rm -rf frontend/dist
```

## 🐢 Addressing the seemingly slow backend

Even though CheckMate is "serverless," it may seem to have a slow backend at times. One of the main reasons for this is the [**Lambda cold start delay**](https://docs.aws.amazon.com/lambda/latest/operatorguide/execution-environments.html#cold-start-latency). Since CheckMate doesn't have a constant user base, most requests are cold starts. However, warm starts of CheckMate Lambdas are significantly faster and well within the reasonable time limits of an HTTP endpoint. Ironically, the more you use CheckMate, the *faster* it becomes! 🚀

A solution to guarantee speed would be to use **provisioned concurrency**, but not only is it more expensive and requires an AWS service request to increase capacity, it also goes against the core principles of serverless architectures.

The solution used here was to beef up the Lambda functions by allocating more **RAM**, which also gives the function more **CPU power**. This reduces cold start delays significantly without deviating from the principles of serverless architecture. 💪
