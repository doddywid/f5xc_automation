Pre-requisite for F5 XC IaaC with Terraform
1. Generate F5XC API Certificate
   - Navigate to Account menu by clicking top right account button
   - Click "Account Setting"
   - Navigate to "Personal Management > Credentials"
   - Click "+Add Credential"
   - Put name, select Credential Type "API Certificate", set Password, set Expiry Date
   - Download PKCS12-formatted API Certificate bundle
2. Extract certificate & key from downloaded PKCS12-formatted API Certificate bundle 
   - Make sure openssl is installed
   - Extracting certificate
     # openssl pkcs12 -info -in <tenant-name>.console.ves.volterra.io.api-creds.p12 -out certificate.cert -nokeys -legacy
   - Extracting private key
     # openssl pkcs12 -info -in <tenant-name>.console.ves.volterra.io.api-creds.p12 -out private_key.key -nodes -nocerts -legacy
3. Use API certificate & private key from step no. 2 above in Terraform variables
   variables.tf
   ============
   variable "api_cert" {
     type = string
     default = "<certificate file folder>/certificate.cert"
   }
   variable "api_key" {
     type = string
     default = "<private key file folder>/private_key.key"
   }
   variable "api_url" {
     type = string
     default = "https://<tenant-name>.console.ves.volterra.io/api"
   }
4. Create terraform tf configuration file
   Use provided example in this folder
