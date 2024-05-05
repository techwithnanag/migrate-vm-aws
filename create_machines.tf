
resource "aws_instance" "public1" {
  ami           = "ami-00b7c9d4042c584a1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id        
  vpc_security_group_ids = [aws_security_group.example_sg.id]  
  tags = {
    Name = "public_instance"
  }
}



