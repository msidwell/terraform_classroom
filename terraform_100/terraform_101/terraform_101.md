- [Terraform 101](#terraform-101)
  - [1.1 Basics](#11-basics)
  - [1.2 Resource Blocks](#12-resource-blocks)
  - [1.3 Variable Blocks](#13-variable-blocks)
  - [1.4 Provider Blocks](#14-provider-blocks)
  - [1.5 Modules](#15-modules)
  - [1.6 Terraform State](#16-terraform-state)
  - [1.7 Terraform Commands](#17-terraform-commands)

# Terraform 101

## 1.1 Basics

Terraform is an open source Infrastructure-as-Code (IaC) solution for
idempotent multi-cloud infrastructure management. Infrastructure components are
defined as declarative code in the form of resource blocks which are stored
within Terraform configuration files. Resource blocks define all aspects of a
given resource within the bounds of the Terraform provider which
handles communication of Terraform code to the resource provider API.

The declarative syntax of Terraform allows for a wide range of choices when it
comes to organization. Any and all \*.tf files within the working directory will
be loaded by Terraform when it is called. For this reason, it is trivial to
break up a set of configuration files into directories with separate variable
files. File structure and file distribution can change depending on the
complexity and needs of a given deployment.

## 1.2 Resource Blocks

[Resource blocks](https://www.terraform.io/docs/configuration/resources.html)
within Terraform files consist of a **resource** declaration with all associated
configuration data contained within. The following example shows a resource
block which defines a subnet in Azure.

```
resource "azurerm_subnet" "subnet001" {
    name = "mySubnet"
    virtual_network_name = "myVnet"
    resource_group_name = "myRG"
    address_prefix = "10.0.0.0/27"
}
```
The two strings after **resource** are the resource type and resource ID
respectively. Resource type is a reference to the Azure resource type for the
**provider** block which will be covered in a later section. The resource ID is
a user-defined tag for the resource which can be referred to using Terraform
**variables**. The combination of type and ID must be unique within a given
Terraform deployment.

Key-value pairs within the resource block define the configuration of the given
resource. Required and optional keys are given by the azurerm provider
specifications.

At Brunswick, these resource blocks will account for the majority of Terraform
code written. They will be used to define all Azure resources that are buildable
using the azurerm provider.

## 1.3 Variable Blocks

[Variables](https://www.terraform.io/docs/configuration/variables.html) in Terraform 
are declared using variable blocks like the example below. They have type, description, 
and default parameters. The type parameter defines the variable as a string, list, or map. 
Descriptions simply act as a comment which gives context to a variable.  The default 
parameter defines the default value of the variable in the event that it is not 
explicitly set.

```
variable "dataDiskCaching" {
  type = "string"
  description = "Caching for data disk (None, ReadOnly, or ReadWrite)"
  default = "ReadOnly"
}
```

Variables can be referenced in multiple ways. They can be explicitly defined
within a variables file using **variable** blocks, environment variables, of
runtime command line inputs. In addition, they can be implicitly defined using
references to resource blocks by using their type and ID. The previous example
**resource** block has been copied below with a few modifications to showcase
the utility of variables in Terraform.

```
resource "azurerm_subnet" "subnet" {
    name = "${var.prefix}subnet"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    resource_group_name = "${azurerm_resource_group.tf_azure_guide.name}"
    address_prefix = "${var.subnet_prefix}"
}
```

Variables are called by using “${}” sets. The entries which start with “var.\*”
refer to explicit variables, while the ones that start with a resource type and
ID refer to other existing configuration values within the Terraform deployment.
Implicit variable references also create dependency links which define the order
in which resources must be created.

For Brunswick resources, all resource values will be defined as variables and
declared in a dedicated variables file. Secure variable declarations will exist
in the master variable file, but associated values will be stored in a
separately stored values file in secure storage for use during package build.

## 1.4 Provider Blocks

Terraform connects to a myriad of infrastructure solutions using intermediate
API translators called [providers](https://www.terraform.io/docs/providers/). For instance, the
[azurerm](https://www.terraform.io/docs/providers/azurerm/index.html) provider can be used to spin 
up resources in Microsoft Azure.

A **provider** block contains all the information needed to initialize a
connection with the infrastructure solution in question. For instance, an
azurerm **provider** block contains the service principal credentials for
accessing a given Azure subscription. In addition to credentials, a version
specification can be added to prevent unwanted provider version upgrades at
build time.

The azurerm provider requires contributor access to an Azure subscription in
order to make changes in that environment. Credentials for said service
principal can be created from the [Azure CLI or the Azure
portal](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html).
Once created, the credentials can be entered in a local shell through az login
or as defined values for automated deployments within Terraform configuration
files.

```
provider "azurerm" {
    version = "~> 1.19"
    subscription_id = "${var.azure_sub_id}"
    client_id = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
    tenant_id = "${var.azure_tenant_id}"
}
```

## 1.5 Modules


Terraform [modules](https://www.terraform.io/docs/modules/index.html) simply
consist of Terraform code that is used as a repeatable group. Any valid
Terraform deployment code can be used as a module. What makes a given set of
Terraform code a module is that it gets called by the root module by using a
[module block](https://www.terraform.io/docs/modules/usage.html). The only
required input for module blocks is the
[source](https://www.terraform.io/docs/modules/sources.html) of the module.
Modules can be sourced from a variety of locations including local files and
GitHub. For example, a local module could be called by the following module
block where the source input is set to a local directory called
“terraform_naming_module”.

```
module "sccm_sn" {

source = "./terraform_naming_module"
    resource_type_input = "subnet"
    business_unit_input = "${var.business_unit}"
    workload = "SCCM"
    environment_input = "${var.environment}"
    location_descriptor_input = "${var.location}"
    naming_index = "01"
}
```

This block not only calls a module, but also passes variables into the module to
use during processing. In addition, modules can use output blocks to pass
resource information and calculated values back to the parent module after
processing. Between module inputs and outputs, their value in repeatability
becomes clear. A single module can be used many times to create similar
resources with slightly different names, sizes, shapes, etc. without reinventing
the wheel every time. Not only does this save time and effort, but can help
maintain consistency between infrastructure admins within an organization since
they can all use the same set of standardized modules in their work.

## 1.6 Terraform State


Known resource states are stored as JSON data in a [state
file](https://www.terraform.io/docs/state/) which Terraform references when
running a plan or apply step to decide whether any resources will be created,
changed, or destroyed. When running Terraform locally, a state file is
automatically created when a plan or apply command is given to Terraform.
However, it is best practice to use a [remote state
file](https://www.terraform.io/docs/state/remote.html) when working in a team
since state files need to be locked during deployments. If team members each had
their own copy of the state file, resource consistency will be lost.

At plan/apply time, Terraform compares the current state of resources with their
expected state in the state file. If a resource deviates from expected state, it
will be recreated during an apply step. Also, if a configuration step fails
during apply then the resource will be marked as tainted for further
remediation. [Workspaces](https://www.terraform.io/docs/state/workspaces.html)
are used to separate code level environment state files from one another while
still using a common set of Terraform configuration files.

State files will be stored remotely in an Azure storage account per code level
environment. Each code level environment state file will be referred to using
Terraform workspaces.

## 1.7 Terraform Commands

The Terraform CLI has a compact set of commands for managing deployments. The
general flow of a Terraform deployment consists of init, plan, and apply steps.
There are other more advanced commands, but those are for specific circumstances
which fall outside the scope of this document.

Terraform [init](https://www.terraform.io/docs/commands/init.html) initializes a
Terraform deployment directory with the required data and provider
specifications for running further Terraform commands. In addition, it will
configure a remote backend if the required credentials and addresses are
present. This command is always safe to run as it does not touch resources.

Terraform [plan](https://www.terraform.io/docs/commands/plan.html) performs a state refresh and compares configuration files to the
current state of resources in a way similar to a [Puppet ```--noop``` run](https://docs.puppet.com/puppet/3.6/man/agent.html#OPTIONS). If a delta is discovered, Terraform will mark that
resource as requiring modification, destruction, or recreation. It then outputs
a full intended configuration set as well as a simplified counter of resources
that will be changed, destroyed, or left untouched. This command can be used to
output a Terraform plan file which is used during the apply step to perform the
exact changes specified by plan. Otherwise, apply will get a plan on its own
when it is run without a specified plan file.

Terraform [apply](https://www.terraform.io/docs/commands/apply.html) performs the actual deployment of resources into a given
environment. By default, it requires user input to confirm a deployment but the
“-autoapprove” flag skips this step. As mentioned above, it will run a plan step
on its own or can be fed a plan file with an expected run set.