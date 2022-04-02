# srehan-assigntment1

This set of terraform scripts will do the following

    create centos instance and deploy apache to it, set the port to 8080 and start it
    create an AMI image of the server above
    create two instances in two different availability zones using from the above created AMI
    creates a load balancer with the two AMI and a self signed certificate for testing use only
    create a route53 dns alias to access the service
    
To run the code do the following

git clone https://github.com/yogibear-sr/srehan-assigntment1.git

# Pre-requsites

Ensure you have the following utilities installed

     ansible
     terraform
     
Also ensure that you have AWS credentials setup to allow CLI connection to their services

After cloning the repository, do the following

     terraform init
     terraform plan

If all is OK do the following

     terraform apply

This will take approxiamtely 10 minutes to run becuase of the following

1) ansible needs to wait for the template server to build and be accessible via ssh
2) the AMI image create needs to wait for ansible to complete before proceeding

It's possible you may get a timeout because sometimes the instance create can be very slow and takes longer than the 5 minutes to come up and complete status checks. If this is the case simply rerun terraform apply or do the following
     
     terraform destroy (yes to confirm)
     terraform apply
     
After this time a set of outputs are display , there should be a route53 record which you can hit as follows

 https://www.skydemo12345.com/
 
It can take sometime for the DNS entry to propogate through but in the meantime a quick test can be to take the elb-dns output string and wrap this as follows

https://SkyDemo-elb-XXXXXXXXX.us-east-1.elb.amazonaws.com/

Because I've used a self-signed certificate , you will need to click on accept risk and continue to page and this will display the apache front page.

When completed testing do the following to remove the service

     terraform destroy (yes to confirm)

# ISSUES
         code needs a tidy up; security needs to be tightened on the rules.
         I would like to destroy the template build server after image create but lack of functions to do this in terraform. 
         I would probably pass the instance details to ansible and destroy from there or use the aws cli in terraform.
         
         
         
# points to consider

1) For monitoring and maintainability I would either use cloudwatch or the clients preferred monitoring service and send alerts using pagerduty to on-call person.
2) for capacity and growth , the count can be increased but if the growth is large then I would add an autoscaling group and use the image to launch the instances.
3) To deploy this into an exiting prod environment , I would either create a seperate vpc and subnets within so there is no overlap or create a new AWS account to run the webservice.

