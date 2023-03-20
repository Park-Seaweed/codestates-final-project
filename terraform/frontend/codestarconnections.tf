resource "aws_codestarconnections_connection" "github_connection" {
  provider_type = "GitHub"
  name = "my-github-connection"
}
