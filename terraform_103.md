- [Terraform 103](#terraform-103)
  - [1.3.1 Outputs](#131-outputs)
  - [1.3.2 Import Resources](#132-import-resources)
  - [1.3.3 Functions](#133-functions)
- [Labs](#labs)
  - [Exercise 1: Generate Outputs](#exercise-1-generate-outputs)
  - [Exercise 2: Import Existing Resources](#exercise-2-import-existing-resources)
  - [Exercise 3: Leverage Functions](#exercise-3-leverage-functions)

# Terraform 103

## 1.3.1 Outputs

[Outputs](https://www.terraform.io/docs/configuration/outputs.html) return specified values after running ```terraform apply```  to be used in other modules, CI workflows, sanity checks, and more. Values returned by ```output``` blocks can take any arbitrary form, often defined as important resource attributes or calculated deployment aggregates. Each unique ```output``` is defined using a block structure similar to ```variable``` definitions where only an ID is defined after the block type declaration and the ```value``` parameter is used to specify an actual output value.

```
output "bastion_public_dns" {
    value       = aws_instance.bastion.public_dns
    description = "Public DNS name of bastion instance"
}
```

These blocks can optionally include the additional parameters ```description```, ```sensitive```, and ```depends_on``` to further customize their behavior. Consuming values from a defined ```output``` in a given child module takes the form of ```module.module_id.output_id```. It is important to define outputs in child modules since resource attributes contained within them are not exposed to parent modules by default.

## 1.3.2 Import Resources

Terraform [```import```](https://www.terraform.io/docs/import/index.html) is a utility that programmatically imports resources not currently managed by a Terraform deployment into a Terraform state file. This is commonly used for slowly transitioning a given set of existing infrastructure for a previously developed service into Terraform management to take advantage of Terraform's state management capabilities. As of version 0.13, the ```import``` command only pulls resources into the state tree and does not write ```resource``` blocks to support the imported resource. Therefore, a "skeleton" ```resource``` block that defines the resrouce type and ID of the target resource is the bare minimum required information for ```import``` to function. A simple workflow for importing a given infrastructure component consists of:

  1. Write a ```resource``` block skeleton that defined the resource type and ID for ```import``` to leverage during state file modification
```
resource "aws_s3_bucket" "legacy" {
}
```
  2. Run the ```import``` command against a given remote resource URI that targets the newly written ```resource``` skeleton type and ID
```
terraform import aws_s3_bucket.legacy old-bucket-c86e32e0
```
  3. Run the ```state show``` command against the newly imported resource to view the parameters of the remote infrastructure

![](_img/tf_classroom_103_state_show.png)

  4. Update the skeleton ```resource``` block to match required and non-default parameters of the remote infrastructure
```
resource "aws_s3_bucket" "legacy" {
    bucket = "old-bucket-c86e32e0"
    acl    = "private"

    tags   = {
        environment = "dev"
        expiration  = "never"
        owner       = "root"
        service     = "k8s"
    }
}
```
  5. Run a ```plan``` to confirm that all parameters match and, if required, update the ```resource``` block as needed to ensure no changes will be made to the remote resource
   
## 1.3.3 Functions

# Labs

## Exercise 1: Generate Outputs

## Exercise 2: Import Existing Resources

## Exercise 3: Leverage Functions