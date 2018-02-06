provider "aws" {
  access_key = "AKIAILWZXJQHEUXXFGOA"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_db_instance" "db_server" {
	engine = "mysql"
	allocated_storage = 20
	instance_class = "db.t2.micro"
	name = "application_db"
	username = "jason"
	password = "H3ll0world!"
}

output "address" { 
	value = "${aws_db_instance.example.address}"
 }

output "port" { 
	value = "${aws_db_instance.example.port}" 
}