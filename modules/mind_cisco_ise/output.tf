output "nlb_sg_id" {
  value = aws_security_group.ise_nlb.id
  description = "security group id for the nlb"
  
}


output "instance_info" {
  value = [
    {
      hostname = aws_instance.ise[0].tags_all.Name
      id       = aws_instance.ise[0].id

    },
    {
      hostname = aws_instance.ise[1].tags_all.Name
      id       = aws_instance.ise[1].id
    },
    {
      hostname = aws_instance.ise[2].tags_all.Name
      id       = aws_instance.ise[2].id
    },
    {
      hostname = aws_instance.ise[3].tags_all.Name
      id       = aws_instance.ise[3].id

    },
    {
      hostname = aws_instance.ise[4].tags_all.Name
      id       = aws_instance.ise[4].id

    },
    {
      hostname = aws_instance.ise[5].tags_all.Name
      id       = aws_instance.ise[5].id

    },
    {
      hostname = aws_instance.ise[6].tags_all.Name
      id       = aws_instance.ise[6].id

    },
    {
      hostname = aws_instance.ise[7].tags_all.Name
      id       = aws_instance.ise[7].id

    },
    {
      hostname = aws_instance.ise[8].tags_all.Name
      id       = aws_instance.ise[8].id

    }
  ]
  description = "list of maps of ise ec2 instances containing (hostname and id)"

}

