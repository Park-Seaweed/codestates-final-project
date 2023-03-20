#resource "aws_cloudfront_origin_access_identity" "demo-s3-project04" {
#  comment = "this is a test distribution"
#}
#
#resource "aws_cloudfront_distribution" "s3_distribution" {
#  origin {
#    domain_name = aws_s3_bucket.demo-tf-test-bucket.bucket_regional_domain_name
#    origin_id   = aws_s3_bucket.demo-tf-test-bucket.id
#    s3_origin_config {
#      origin_access_identity = aws_cloudfront_origin_access_identity.demo-s3-project04.cloudfront_access_identity_path
#    }
#  }
#  enabled             = true
#  is_ipv6_enabled     = true
#  comment             = "Some comment"
#  default_root_object = "index.html"
#
#  aliases = ["test.devops03-gg.click"]
#
#  default_cache_behavior {
#    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#    cached_methods         = ["GET", "HEAD"]
#    target_origin_id       = aws_s3_bucket.demo-tf-test-bucket.id
#    viewer_protocol_policy = "redirect-to-https"
#    cache_policy_id        = aws_cloudfront_cache_policy.demo-cache-policy.id
#  }
#  price_class  = "PriceClass_All"
#  http_version = "http2"
#  logging_config {
#    bucket          = aws_s3_bucket.demo-tf-test-bucket-log.bucket_domain_name
#    include_cookies = true
#    prefix          = "demo"
#  }
#  viewer_certificate {
#    acm_certificate_arn      = "arn:aws:acm:us-east-1:901512289056:certificate/6b980158-33fc-4956-9695-c1fe2d8bd460"
#    minimum_protocol_version = "TLSv1.2_2021"
#    ssl_support_method       = "sni-only"
#  }
#  # 지리적 제한: 특정 국가에서만 접근하도록 화이트리스트 작성 -> none 
#  restrictions {
#    geo_restriction {
#      restriction_type = "none"
#    }
#  }
#}
#
## aws_cloudfront_cache_policy
#resource "aws_cloudfront_cache_policy" "demo-cache-policy" {
#  name = "demo-cache-policy"
#
#  comment = "Cache policy for demo"
#
#  min_ttl     = 0
#  default_ttl = 86400
#  max_ttl     = 31536000
#
#  parameters_in_cache_key_and_forwarded_to_origin {
#    cookies_config {
#      cookie_behavior = "none"
#    }
#    headers_config {
#      header_behavior = "none"
#    }
#    query_strings_config {
#      query_string_behavior = "none"
#    }
#    enable_accept_encoding_brotli = true
#    enable_accept_encoding_gzip   = true
#  }
#}
#
## 추가 CloudWatch 지표 활성화
#resource "aws_cloudfront_monitoring_subscription" "demo-Indicator" {
#  distribution_id = aws_cloudfront_distribution.s3_distribution.id
#
#  monitoring_subscription {
#    realtime_metrics_subscription_config {
#      realtime_metrics_subscription_status = "Enabled"
#    }
#  }
#}