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
