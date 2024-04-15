resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "CloudWatchAgentRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cloudwatch_agent_attachment" {
  name       = "CloudWatchAgentAttachment"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.cloudwatch_agent_role.name]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile-for-cloudwatch-agent"
  role = aws_iam_role.cloudwatch_agent_role.name
}
