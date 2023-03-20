# codepipeline

resource "aws_codepipeline" "pipeline" {
  name     = "${var.source_repo_name}-${var.source_repo_branch}-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
  location = aws_s3_bucket.artifact_bucket.bucket
  type     = "S3"
}
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeStarSourceConnection"
      output_artifacts = ["source_output"]

      
      configuration = {
        FullRepositoryId     = "${var.github_Owner}/${var.source_repo_name}"
        BranchName           = var.source_repo_branch
        ConnectionArn        = aws_codestarconnections_connection.github_connection.arn
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      run_order        = 1
      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.demo-tf-test-bucket.bucket
        Extract    = "true"
      }
    }
  }
}

#iam policy
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect    = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      aws_s3_bucket.artifact_bucket.arn,
      aws_s3_bucket.demo-tf-test-bucket.arn,
      "${aws_s3_bucket.artifact_bucket.arn}/*",
      "${aws_s3_bucket.demo-tf-test-bucket.arn}/*"
    ]
  }
  statement {
    effect   = "Allow"
    actions  = ["codestar-connections:UseConnection"]
    resources = ["*"]
  }
    statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name       = "codepipeline_policy"
  role       = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}
