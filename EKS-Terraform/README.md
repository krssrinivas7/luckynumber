# Provisioning of EKS using Terraform

## Creation of Instance having Terraform

- Create any instance and install terraform to create EKS Cluster

## Creation of S3 Bucket

To keep .tfstate file in S3 bucket
- Create a bucket name "terra-eks-backend"
- ACL disabled
- Bucket versioning Enabled.

## Creation of Dynamo DB Table

To make .tfstate file consistent better to enable state-locking,  File locking is a data management feature that allows only one user or process access to a file at any given time. It restricts other users from changing the file while it is being used by another user or process.

- Go to DynamoDB
- Create Table
- Table Name = EKS-TERRA-TABLE
- Partition key = LOCKID
- Then click create table

## Creation of Terraform files

- [Eks-Backend-Terra file](./Eks-Backend-Terra.tf)
- [Provider file](./Provider.tf)
- [VPC file](./VPC.tf)
- [Subnets file](./Subnets.tf)
- [Internetgw file](./Internetgw.tf)
- [Rout file](./Rout.tf)
- [Security group file](./Sg.tf)
- [Iam_role file](./Iam_role.tf)
- [Eks_Cluster file](./Eks_Cluster.tf)
- [Eks_Node_group file](./Eks_Node_group.tf)

## Post Actions to be performed

- After creation of EC2 Instance by terraform, make sure that you are having same keypair which was given in creation of nodegroup.
- Connect the machine by using SSH, install aws cli, kubectl, eksctl, Terraform.
- Apply the below command

```
aws eks --region us-east-1 describe-cluster --name pc-eks --query cluster.status
aws eks --region us-east-1 update-kubeconfig --name pc-eks
```

- Type following command to fetch the created nodes and verify whether they are working under master plane or not

```
kubectl get nodes
```

- After updating Created EKS Cluster then start using Kubernetes concepts


# Conclusion

_*This illustrates how to create EKS Cluster using Terraform using simple files*_
