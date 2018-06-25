resource "aws_iam_policy" "pks_master" {
    name = "${var.env_name}_pks_master"
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::kubernetes-*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": "ec2:Describe*",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "ec2:AttachVolume",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": "ec2:DetachVolume",
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:*"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "elasticloadbalancing:*"
        ],
        "Resource": [
            "*"
        ]
    }
]
}
EOF
}

resource "aws_iam_policy" "pks_worker" {
    name = "${var.env_name}_pks_worker"
    policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Action": "ec2:Describe*",
        "Effect": "Allow",
        "Resource": "*"
    },
    {
        "Action": "ec2:AttachVolume",
        "Effect": "Allow",
        "Resource": "*"
    },
    {
        "Action": "ec2:DetachVolume",
        "Effect": "Allow",
        "Resource": "*"
    }
]
}
EOF
}

resource "aws_iam_user" "pks_master" {
    name = "${var.env_name}_pks_master"
}

resource "aws_iam_access_key" "pks_master" {
    user = "${aws_iam_user.pks_master.name}"
}

resource "aws_iam_user_policy_attachment" "pks_master" {
    user       = "${aws_iam_user.pks_master.name}"
    policy_arn = "${aws_iam_policy.pks_master.arn}"
}

resource "aws_iam_user" "pks_worker" {
    name = "${var.env_name}_pks_worker"
}

resource "aws_iam_access_key" "pks_worker" {
    user = "${aws_iam_user.pks_worker.name}"
}

resource "aws_iam_user_policy_attachment" "pks_worker" {
    user       = "${aws_iam_user.pks_worker.name}"
    policy_arn = "${aws_iam_policy.pks_worker.arn}"
}