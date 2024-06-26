resource "aws_elb" "bar" {
  name               = "nikhil-terraform-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.one.id}", "${aws_instance.two.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  tags = {
    Name = "nikhil-tf-elb"
  }
}

resource "aws_subnet" "database-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Database-1a"
  }
}

resource "aws_subnet" "database-subnet-2" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Database-2b"
  }
}


 resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  availability_zones      = ["us-east-1a","us-east-1b","us-east-1d"]
  database_name           = "mydb"
  master_username         = "nikhil"
  master_password         = "Nikhil#0402"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}

/*resource "aws_instance" "one" {
  for_each = toset(["one", "two", "three"])
  ami           = "ami-006be9ab6a140de6e"
  instance_type = "t2.micro"
  tags = {
    Name = "instance-${each.key}"
  }
}*/

