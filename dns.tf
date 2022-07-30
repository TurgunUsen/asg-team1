resource "aws_route53_zone" "main" {
  name = "usentechnology.com"
}

resource "aws_route53_zone" "wordpress" {
  name = "wordpress.usentechnology.com"

  tags = {
    Name = "Team1"
  }
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "wordpress.usentechnology.com"
  type    = "A"
  ttl     = "30"
  records = aws_route53_zone.wordpress.name_servers

}