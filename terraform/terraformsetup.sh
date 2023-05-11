#!/bin/bash 

password=$1
if [ -z "$password" ]; then 
    echo "Please select a password for the terraform user account to use. The syntax of this script is terraformsetup.sh <password>";
    exit
fi
if ! command -v pveum &>/dev/null; then
    echo "The pveum command cannot be found. Are you sure you are using proxmox?"
    exit
fi

pveum user delete terraform-prov@pve
pveum role delete TerraformProv 

pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum user add terraform-prov@pve --password $password 
pveum aclmod / -user terraform-prov@pve -role TerraformProv

touch credentials.tfvars

echo 'PM_USER="terraform-prov@pve"' > credentials.tfvars

echo -n 'PM_PASSWORD="' >> credentials.tfvars
echo -n $password >> credentials.tfvars
echo  '"' >> credentials.tfvars

terraform init

echo "MAKE ME PRETTIER"
