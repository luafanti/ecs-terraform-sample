# ECS terraform

Terraform stack for ECS platform and custom service exposed via ALB & CloudFront

## Terraform Setup

### Prerequisites

Set your AWS profile if you don't want to use the "default"
```
$ export AWS_PROFILE=my-profile
```


Initialize Terraform. Stack will use local state to simplify setup
```
$ cd env/dev
$ terraform init 
```

Prepare variables. You can use of sample terraform vars file.  
```
$ cp terraform.tfvars.dna-sample terraform.tfvars
```

Few variables need to be customized

* `aws_allowed_account_ids` - ID of your AWS account

* `route53_zone_name` - this stack will not create Route53 Hosted Zone. It assumes that you already have one. Stack will just add DBS records for ALB & CF to it.


### Apply Terraform plan

Plan your Terraform infrastructure and check if configured as desired before applying.
```
$ terraform plan -out terraform.tfplan
```

Apply your Terraform infrastructure plan.
```
$ terraform apply terraform.tfplan
```
Confirm with `yes`.

## Modules hierarchy

Terraform stack consist of two main modules

* ecs_platform `modules/ecs/platform` - create VPC and ECS cluster in it.
* ecs_service `module/ecs/service` - create ECS service and other components dedicated it like ALB or CloudFront.

Rest of modules are sub-modules used by above main modules.

## Configuration

Terraform stack consist of two main modules

* ecs_platform `modules/ecs/platform` - create VPC and ECS cluster in it.
* ecs_service `module/ecs/service` - create ECS service and other components dedicated it like ALB or CloudFront.

Rest of modules are sub-modules used by above main modules.

## Cost of infrastructure
Cost summary generated by [Infrcost](https://www.infracost.io/)

```
 Name                                                                                   Monthly Qty  Unit                    Monthly Cost 
                                                                                                                                          
 module.ecs_platform.module.vpc.module.this.aws_eip.nat[0]                                                                                
 └─ IP address (if unused)                                                                      730  hours                          $3.65 
                                                                                                                                          
 module.ecs_platform.module.vpc.module.this.aws_nat_gateway.this[0]                                                                       
 ├─ NAT gateway                                                                                 730  hours                         $35.04 
 └─ Data processed                                                                Monthly cost depends on usage: $0.048 per GB            
                                                                                                                                          
 module.ecs_service.module.acm.module.acm[0].aws_route53_record.validation[0]                                                             
 ├─ Standard queries (first 1B)                                                   Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                      Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                    Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                          
 module.ecs_service.module.cdn[0].module.cdn.aws_cloudfront_distribution.this[0]                                                          
 ├─ Invalidation requests (first 1k)                                              Monthly cost depends on usage: $0.00 per paths          
 └─ US, Mexico, Canada                                                                                                                    
    ├─ Data transfer out to internet (first 10TB)                                 Monthly cost depends on usage: $0.085 per GB            
    ├─ Data transfer out to origin                                                Monthly cost depends on usage: $0.02 per GB             
    ├─ HTTP requests                                                              Monthly cost depends on usage: $0.0075 per 10k requests 
    └─ HTTPS requests                                                             Monthly cost depends on usage: $0.01 per 10k requests   
                                                                                                                                          
 module.ecs_service.module.cdn_dns[0].aws_route53_record.a_record                                                                         
 ├─ Standard queries (first 1B)                                                   Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                      Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                    Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                          
 module.ecs_service.module.cw.aws_cloudwatch_log_group.this                                                                               
 ├─ Data ingested                                                                 Monthly cost depends on usage: $0.57 per GB             
 ├─ Archival Storage                                                              Monthly cost depends on usage: $0.03 per GB             
 └─ Insights queries data scanned                                                 Monthly cost depends on usage: $0.0057 per GB           
                                                                                                                                          
 module.ecs_service.module.lb[0].module.alb.aws_lb.this[0]                                                                                
 ├─ Application load balancer                                                                   730  hours                         $18.40 
 └─ Load balancer capacity units                                                  Monthly cost depends on usage: $5.84 per LCU            
                                                                                                                                          
 module.ecs_service.module.lb_dns[0].aws_route53_record.a_record                                                                          
 ├─ Standard queries (first 1B)                                                   Monthly cost depends on usage: $0.40 per 1M queries     
 ├─ Latency based routing queries (first 1B)                                      Monthly cost depends on usage: $0.60 per 1M queries     
 └─ Geo DNS queries (first 1B)                                                    Monthly cost depends on usage: $0.70 per 1M queries     
                                                                                                                                          
 OVERALL TOTAL                                                                                                                     $57.09 
```

*The biggest cost is the NAT Gateway, which is needed only to download docker images from public repositories and install them in a private subnet of ECS


## Restrictions

CloudFont will work only with Second Level Domains e.g. **example.com** `route53_zone_name = "example.com"`

It will NOT work with Sub Domains `route53_zone_name = "sub.example.com"`. This is because for Cloud Front Terraform will generate SSL certificate in ACM which can cover only single level of Sub Domain.  

## Possible improvements

- SSL certificate for ALB and SG for HTTPS
- possibility to deploy multiple ECS services 
- clean up variables and modules
