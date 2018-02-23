provider "aws" {
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
	value = "${aws_db_instance.db_server.address}"
 }

output "port" { 
	value = "${aws_db_instance.db_server.port}" 
}
