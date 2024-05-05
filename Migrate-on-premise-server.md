### `Prerequisites:` Install AWS CLI and configure a user with proper permissions\.
PART 1\: Secure connection between AWS and on\-premise data center
PART 2\: Copy large virtual machine  files to AWS
PART 3\: Covert virtual machine files to AMI

# PART ONE

### `Create vpc, S3 bucket terraform`
- [x] **Create vpc\(networking\) and S3 bucket with  terraform** 

### **`Secure connection with Openvpn`** \*\*\*\*
- [x] **Establish secure connection between AWS  VPC and On\-premise data center with openvpn**
* Create openvpn access server on aws 
* create a user and download the profile
* install openvpn client cli on on\-premise server 
* configure the on\-premise server with the profile 
```warp-runnable-command
sudo openvpn --config client.ovpn

```
***









# Part 2 


### `Copy vm images ova, vmkd, vhk etc to S3 bucket`\*\*\*\*
- [x] **Copy vm images ova\, vmkd\, vhk etc to S3 bucket** 
```warp-runnable-command
aws s3 mb s3://migrate-bucket-003/ 

aws  s3 cp techwithso4-server.ova  s3://migrate-bucket-003/

```
```warp-runnable-command


NOTE: upload large file with multipart upload
https://repost.aws/knowledge-center/s3-multipart-upload-cli 

     split -b 500MB tomcat.ova
     install and use s3 browser 







```
## `####Aws import/export role and policy####`
```warp-runnable-command
 https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html 

```
```warp-runnable-command
 aws iam create-role --role-name vmimport --assume-role-policy-document file://trust-policy.json



```
```warp-runnable-command

cat << EOF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "vmie.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "vmimport"
        }
      }
    }
  ]
}
EOF


```
```warp-runnable-command
aws iam create-policy --policy-name vmimport --policy-document file://role-policy.json


```
```warp-runnable-command
cat << EOF > role-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF

aws iam create-policy --policy-name vmimport --policy-document file://role-policy.json



```
```warp-runnable-command
aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document "file://role-policy.json" 
```
***
## Finally create ami
```warp-runnable-command
aws ec2 import-image --description "My server VM" --disk-containers file://containers.json
```
Create a  [containers\.json](file://c:/import/containers.json)
```warp-runnable-command

cat << EOF > containers.json 
[
{
    "Description": "My Server OVA",
    "Format": "ova",
    "Url": "s3://migrate-bucket-003/techwithso4-server.ova"
  }
]
EOF

```
```warp-runnable-command
Check the status 

aws ec2 describe-import-image-tasks --import-task-ids import-ami-0e85f7b80b90c8a55
```
reference 
```warp-runnable-command



```
***
- [x] **Testing AMI**
