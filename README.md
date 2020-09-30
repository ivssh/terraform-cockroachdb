# Terraform CockroachDB

Launch cockroachdb clusters in AWS using `remote` provisioners.

### What's possible

  - spin up **insecure** cockroachdb clusters
  - Both in public subnet and private subnet
  - One time setup of nodes with cockroachdb
  - Loadbalancer to route requests to all the nodes on `port 26257`

### Pre-requisites

  - Terraform installed
  - AWS CLI installed and configured with access key and secret
  - Ensure the **pem file** is in `~/.ssh`
  - Add the public key of the corresponding pem file to `artifacts.tf` in `"aws_key_pair" "deployment"` resource

## Steps to launch a cockroachdb cluster

#### Default settings
```sh
$ terraform init
$ terraform plan -out=cockroach_cluster.tfplan
$ terraform apply "cockroach_cluster.tfplan"
```

#### Variable number of instances
```sh
$ terraform init
$ terraform plan -out=cockroach_cluster.tfplan
$ terraform apply -var 'num_of_instaces=<any_integer>' "cockroach_cluster.tfplan"
```

#### Testing the infrastructure

Ssh into the bastion instance which is public facing
```sh
$ ssh -i <pem-file> ubuntu@<public-ip-of-bastion-instance>
```

Test the client connection to all the nodes through the loadbalancer
```sh
$  cockroach node status --insecure --host=<private-DNS-of-internal-loadbalancer>
```
#### References
- https://www.cockroachlabs.com/docs/v20.1/deploy-cockroachdb-on-aws-insecure

#### License
This project is distributed under the Apache License Version 2.0