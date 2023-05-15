VENVDIR=env
ANSIBLE_VERSION=2.12
virtualenv  --python=$(which python3) $VENVDIR
source $VENVDIR/bin/activate
pip install -U -r .requirements.txt

ansible-galaxy install -r .requirements.yml

# Uhhh idk if this works or not, seems cool tho
#wget https://github.com/adammck/terraform-inventory/releases/download/v0.10/terraform-inventory_v0.10_linux_amd64.zip
#unzip -o terraform-inventory_v0.10_linux_amd64.zip
#chmod +x terraform-inventory
#rm terraform-inventory_v0.10_linux_amd64.zip

