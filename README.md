#Gradle for TFS Build automation
####Introduction to Gradle

Gradle is an open source build and automation tool for any extended community of JAVA and been gaining in popularity within Java, Groovy and Scala communities, as it supports the automation of building, testing, publishing and deploying of software packages or other types of projects, such as generated static websites and generated documentation. Key features of Gradle includes Declarative builds and build-by-convention, Deep API, Scalability and wrapper scripts.

Please refer [Gradle Overview](http://www.gradle.org/overview) for more details.

####Introduction to TFS 2013 in brief
TFS build is a workflow based build and automation system and can work with TFS and Git repositories.

Please refer [TFS Overview](http://www.visualstudio.com/en-us/products/tfs-overview-vs.aspx) for more details.

####Gradle for TFS build automation
TFS can now run Gradle build and automation tasks as part of its workflow and on required, it can deliver the built binaries/application to Windows/Linux Azure VM.

###Pre-Requisite for Gradle build on TFS

![alt tag](https://cloud.githubusercontent.com/assets/1798439/3269446/7e8e75e4-f2ed-11e3-9cb9-9a1953d88ac3.jpg)

* On-premises TFS Server
  - TFS Build 2013
  - Code should be checked into Git source control
  - Can’t use TFS Online for this Gradle build
* Client Machine
  - Team Explorer 2013 (To create build definition)
* Server hosting Team Foundation Build Agent
	- Java to be installed.
		- JDK version - 1.6 or higher
		- JAVA_HOME environment variable to be set
	- Gradle version - 1.9 or higher
		- For ‘gradle’ command:
			- Gradle to be installed
			- GRADLE_HOME environment variable to be set
			
####For continues deployment
* Download the build template [GradleGitTemplate.12.xaml](https://github.com/MSOpenTech/TFS-Gradle-plugin/blob/master/GradleGitTemplate.12.xaml)
	- [BuildProcess.dll](https://github.com/MSOpenTech/TFS-Gradle-plugin/tree/master/BuildTemplate/BuildProcess/bin) to GAC (On build agent machine and on build configuration machine)
* Point to build controller and configure the properties as,
	- “version control path to custom assemblies” as mapped to BuildProcess project path(library is chipped with the Github repository) or BuildProcess.dll from GAC
* Server hosting Team Foundation Build Agent
	- Windows Azure PowerShell
	- For Windows VM:
		- WinRM Config for Client as follows:
			- winrm quickconfig
			- winrm set winrm/config/client/auth '@{Basic="true"}'
		- Download the SSL Certificate of the Azure Cloud Service hosting and store it on the File System
		- For some useful script for configuring a VM to take remote control
			- https://github.com/MSOpenTech/TFS-Gradle-plugin/tree/master/Other%20useful%20script 
	- For Linux VM
		- OpenSSH or any tool that provides an SSH client for Windows
		- Path of ssh.exe to be added to environment variable %PATH% on Build Agent.
		- SSH private key to be saved on the File system. The full path to this file should be provided to the Build Definition. 
		- If there are multiple Build Agents configured, you can choose to store the private key in a shared drive to which all Build Agents have access to. 
		- If required, Link for [how to create SSH private key file from windows](http://azure.microsoft.com/en-us/documentation/articles/linux-use-ssh-key/)
		
		**NOTE:** If any of the above mentioned Environment variables are newly set, then the TFS Build Service should be restarted for updated environment variables
* Azure Storage
	- Storage Account should be created
	- Access Key to be provided to Build Template
	- Container should be created
* Azure VMs
	- Windows VM: 
		- If more than one VM’s are targeted for Continuous Deploy then, 
			- All VM’s should be under the same cloud storage and 
			- All the Azure VMs provisioned under this Cloud Service should have the same "User name and Password"
		- WinRM Config as follows (The following should be executed on Windows Azure Elevated PowerShell / Command Prompt window on the VM. You can do it via RDP):
			- winrm quickconfig
			- winrm set winrm/config/service/auth '@{Basic="true"}'
	- Linux VM:
		- If more than one VM’s are targeted for Continuous Deploy then, 
			- All VM’s should be under the same cloud storage and 
			- All the Azure VMs provisioned under this Cloud Service should have the same SSH certificate configured
		- SSH server to be running on the Linux VM
		- The VM should use SSH Key for Authentication. Link for [Configuration details](http://azure.microsoft.com/en-us/documentation/articles/linux-use-ssh-key/)
		- In case your VM is already provisioned and uses Username/password authentication, then generate the SSH Keys as mentioned in the link above. Then add the data in myCert.pem to /home/<username>/.ssh/authorized_keys file. 
