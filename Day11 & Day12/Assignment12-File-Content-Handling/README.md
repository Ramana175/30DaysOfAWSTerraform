# Assignment 12: File Content Handling in Terraform

## Objective

Learn how to read a JSON configuration file, decode its contents, and store secrets in AWS Secrets Manager using Terraform.

---

## Functions Covered

### 1. `file()`

Reads the contents of a file and returns it as a string.

**Syntax:**

```hcl
file("filename.json")
```

**Example:**

```hcl
locals {
  config_content = file("config.json")
}
```

---

### 2. `jsondecode()`

Converts a JSON string into a Terraform map/object.

**Syntax:**

```hcl
jsondecode(string)
```

**Example:**

```hcl
locals {
  config = jsondecode(file("config.json"))
}
```

If `config.json` contains:

```json
{
  "username": "admin",
  "password": "mypassword123"
}
```

Terraform converts it into:

```hcl
{
  username = "admin"
  password = "mypassword123"
}
```

---

### 3. `jsonencode()`

Converts a Terraform object into a JSON string.

**Syntax:**

```hcl
jsonencode(object)
```

**Example:**

```hcl
secret_string = jsonencode({
  username = "admin"
  password = "mypassword123"
})
```

Output:

```json
{
  "username": "admin",
  "password": "mypassword123"
}
```

---

## Project Structure

```text
assignment-12/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── config.json
└── README.md
```

---

## Step 1: Create JSON Configuration File

### config.json

```json
{
  "username": "admin",
  "password": "mypassword123"
}
```

---

## Step 2: Terraform Configuration

### main.tf

```hcl
provider "aws" {
  region = "ap-south-1"
}

locals {
  config = jsondecode(file("${path.module}/config.json"))
}

resource "aws_secretsmanager_secret" "app_secret" {
  name = "app-secret"
}

resource "aws_secretsmanager_secret_version" "app_secret_value" {
  secret_id = aws_secretsmanager_secret.app_secret.id

  secret_string = jsonencode({
    username = local.config.username
    password = local.config.password
  })
}
```

---

## Terraform Commands

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Preview Changes

```bash
terraform plan
```

### Apply Changes

```bash
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

---

## Verification

Check AWS Secrets Manager:

1. Open AWS Console.
2. Navigate to Secrets Manager.
3. Locate `app-secret`.
4. View secret value.

Expected Secret:

```json
{
  "username": "admin",
  "password": "mypassword123"
}
```

---

## Real-Time Use Cases

### Application Credentials

Store database usernames and passwords securely.

### API Keys

Read API keys from configuration files and store them in Secrets Manager.

### Environment Configuration

Manage environment-specific settings such as:

* Development
* Testing
* Production

### CI/CD Pipelines

Store deployment secrets securely and retrieve them during application deployment.

---

## Key Learnings

* Used `file()` to read external files.
* Used `jsondecode()` to convert JSON into Terraform objects.
* Used `jsonencode()` to convert Terraform objects into JSON.
* Created and managed secrets using AWS Secrets Manager.
* Improved security by avoiding hardcoded credentials in Terraform code.

---

## Conclusion

This assignment demonstrates how Terraform can read external JSON configuration files, process the data using `jsondecode()`, convert it back into JSON using `jsonencode()`, and securely store sensitive information in AWS Secrets Manager.
