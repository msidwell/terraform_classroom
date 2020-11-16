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

## 1.3.3 Functions

# Labs

## Exercise 1: Generate Outputs

## Exercise 2: Import Existing Resources

## Exercise 3: Leverage Functions