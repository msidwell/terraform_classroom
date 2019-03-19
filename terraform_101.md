- [Terraform 101](#terraform-101)
  - [1.1.1 Basics](#111-basics)
  - [1.1.2 Resource Blocks](#112-resource-blocks)
  - [1.1.3 Variable Blocks](#113-variable-blocks)
  - [1.1.4 Terraform Commands](#114-terraform-commands)
  - [1.1.5 Creating Terraform Files](#115-creating-terraform-files)
- [Labs](#labs)
  - [Exercise 1: Creating a Resource](#exercise-1-creating-a-resource)
  - [Exercise 2: Using Variables](#exercise-2-using-variables)
  - [Exercise 3: Organizing with .tf Files](#exercise-3-organizing-with-tf-files)

# Terraform 101

## 1.1.1 Basics

Terraform is an open source Infrastructure-as-Code (IaC) solution for idempotent multi-cloud infrastructure management. Infrastructure components are defined as declarative code in the form of resource blocks which are stored within Terraform configuration files. Resource blocks define all aspects of a given resource within the bounds of the Terraform provider which handles communication of Terraform code to the resource provider API.

Terraform code is written in [Hashicorp Configuration Language](https://github.com/hashicorp/hcl) (HCL). This language follows a block-based structure allowing for simple constrcution and readability. The declarative syntax of Terraform allows for a wide range of choices when it comes to organization. Any and all \*.tf files within the working directory willbe loaded by Terraform when it is called. For this reason, it is trivial to break up a set of configuration files into directories with separate variable files. File structure and file distribution can change depending on the complexity and needs of a given deployment.

## 1.1.2 Resource Blocks

[Resource blocks](https://www.terraform.io/docs/configuration/resources.html) within Terraform files consist of a **resource** declaration with all associated configuration data contained within. The following example shows a resource block which defines a subnet in Azure.

```
resource "azurerm_subnet" "subnet001" {
    name                 = "mySubnet"
    virtual_network_name = "myVnet"
    resource_group_name  = "myRG"
    address_prefix       = "10.0.0.0/27"
}
```

The two strings after **resource** are the resource type and resource ID respectively. Resource type is a reference to the Azure resource type for the **provider** block which will be covered in a later section. The resource ID is a user-defined tag for the resource which can be referred to using Terraform **variables**. The combination of type and ID must be unique within a given Terraform deployment.

Key-value pairs within the resource block define the configuration of the given resource. Required and optional keys are given by the azurerm provider specifications.

## 1.1.3 Variable Blocks

[Variables](https://www.terraform.io/docs/configuration/variables.html) in Terraform are declared using variable blocks like the example below. They have type, description, and default parameters. The type parameter defines the variable as a string, list, or map. Descriptions simply act as a comment which gives context to a variable.  The default parameter defines the default value of the variable in the event that it is not explicitly set.

```
variable "dataDiskCaching" {
  type        = "string"
  description = "Caching for data disk (None, ReadOnly, or ReadWrite)"
  default     = "ReadOnly"
}
```

Variables can be referenced in multiple ways. They can be explicitly defined within a variables file using **variable** blocks, environment variables, of runtime command line inputs. In addition, they can be implicitly defined using references to resource blocks by using their type and ID. The previous example **resource** block has been copied below with a few modifications to showcase the utility of variables in Terraform.

```
resource "azurerm_subnet" "subnet" {
    name = "${var.prefix}subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    resource_group_name = "${azurerm_resource_group.tf_azure_guide.name}"
    address_prefix = "${var.subnet_prefix}"
}
```

Variables are called by using “${}” sets. The entries which start with “var.\*” refer to explicit variables, while the ones that start with a resource type and ID refer to other existing configuration values within the Terraform deployment. Implicit variable references also create dependency links which define the order in which resources must be created.

## 1.1.4 Terraform Commands

The Terraform CLI has a compact set of commands for managing deployments. The general flow of a Terraform deployment consists of init, plan, and apply steps. There are other more advanced commands, but those are for specific circumstances which fall outside the scope of this document.

Terraform [init](https://www.terraform.io/docs/commands/init.html) initializes a Terraform deployment directory with the required data and provider specifications for running further Terraform commands. In addition, it will configure a remote backend if the required credentials and addresses are present. This command is always safe to run as it does not touch resources.

Terraform [plan](https://www.terraform.io/docs/commands/plan.html) performs a state refresh and compares configuration files to the current state of resources in a way similar to a [Puppet ```--noop``` run](https://docs.puppet.com/puppet/3.6/man/agent.html#OPTIONS). If a delta is discovered, Terraform will mark that resource as requiring modification, destruction, or recreation. It then outputs a full intended configuration set as well as a simplified counter of resources that will be changed, destroyed, or left untouched. This command can be used to output a Terraform plan file which is used during the apply step to perform the exact changes specified by plan. Otherwise, apply will get a plan on its own when it is run without a specified plan file.

Terraform [apply](https://www.terraform.io/docs/commands/apply.html) performs the actual deployment of resources into a given environment. By default, it requires user input to confirm a deployment but the “-autoapprove” flag skips this step. As mentioned above, it will run a plan step on its own or can be fed a plan file with an expected run set.

## 1.1.5 Creating Terraform Files

File structures in a Terraform deployments are quite flexible, though there are a few organizational tricks to keep in mind. There are three file extension patterns to be aware of, namely ```*.tf```, ```*.tfvars```, and ```*.auto.tfvars``` which each have unique usages. ```*.tf``` files contain any sort of HCL block and are automatically loaded by Terraform if they are in the working directory. ```*.tfvars``` files contain key=value pairs which set variable values for variables declared in ```*.tf``` files but must be intentionally loaded at runtime by using the ```--var-file``` parameter. Alternatively, ```*.auto.tfvars``` files are the same as the previous ```*.tfvars``` files except they will automatically be loaded into memory by Terraform if they are in the working directory. In most deployments, it is sufficient to use one ```*.tf``` file for resource blocks, another for variable blocks, and a final ```*.tfvars``` file for inputting variable values.

# Labs

## Exercise 1: Creating a Resource

Create a resource block for your preferred resource provider. Good starting resources are resources with few required parameters like an [AWS S3 bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html) or [Azure resource group](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html).

Test the structure of your .tf file by running ```terraform init``` or ```terraform validate```. Make sure you try actually deploying the resource by using your preferred CLI to login to the resource provider and running ```terraform apply```. For instance, log into the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) using ```aws configure``` or log into the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest#az-login) using ```az login```

Your answer should look similar to the example provided in [section 1.1.2](#12-resource-blocks)

## Exercise 2: Using Variables

Using the resource block created in the [first exercise](#exercise-1-creating-a-resource), turn all of the hardcoded resource parameters
into variable references. This requires that you declare a variable block for each parameter referenced in this manner.

As before, make sure to test your configuration using a combination of ```terraform init```, ```terraform validate```, and ```terraform apply```. You will be asked to input values for your variables at plan/apply time.

Your resource block should look similar to the resource example in [section 1.1.3](#13-variable-blocks), and it should be accompanied by a number of variable blocks which look like the example declaration in that same section.

## Exercise 3: Organizing with .tf Files

Using the file contents from the [second exercise]((#exercise-2-using-variables)), create a second .tf file and move your variable declarations to it. Test and apply your configuration and see that it creates the same resource as your answer form the previous exercise.