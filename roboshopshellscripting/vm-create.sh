echo " Creating Vm automatically using CLI "



for component in catalogue user cart payment shipping frontend mongodb redis mysql rabbitmq dispatch ; do
az vm create --resource-group SUDHA_RG --name $component --image OpenLogic:CentOS-LVM:8-lvm-gen2:8.5.2022101401 --vnet-name SUDHA_RGvnet901 --subnet default  --admin-username centos --admin-password DevOps654321 --public-ip-address "" --size Standard_B1s
az vm auto-shutdown -g SUDHA_RG -n  $component --time 1230  
done

