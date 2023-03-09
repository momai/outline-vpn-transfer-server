ansible-galaxy collection install community.dns

ansible-playbook move_outline.yml --extra-vars "new_server_ip=$(terraform output -raw new_server_ip)"
