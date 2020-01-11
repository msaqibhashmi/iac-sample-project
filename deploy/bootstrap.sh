#!/bin/bash
#
USER="msaqibhashmi"
HOSTNAME="demo-project"

# Add User
adduser -m $USER
usermod -aG adm $USER
usermod -aG wheel $USER
usermod -aG systemd-journal $USER
mkdir -p /home/$USER/.ssh

cat << "EOF" | tee /home/$USER/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJgvqHf4yvRUwsThQc6MvT8zLBEP8ixknm0NcMUaVn0n+OLnLc1zWlTRehk86CH1vLiHQEz47PbAMgiDKpTeVWYt/rlRagUMFdOB7Ry4b5v7q9orniGZQ9XNz2MIOFnkDEGeEmxSCv6x23uzXmASRKYkfdBVvh1gV/R3gnjfNhf//C00thMrJ0MyfQ0VeDNds4Vw0uc5bi7rw9QAKjdvsxuD3yclrpTzQnlDZZDr0J3I8Wq6VuCbQseQrXyqcXspyy9mZtj8eIOvq1U+vvoBswqarkWo1o8CQw0930MK36VsGTfO/GDdBDDKoy8W8OVRHwMEXQZ2xTXeaG6joyw18/ msaqibhashmi-ssh-pubKey
EOF

chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER
echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/power-users

# Hostname
cat > /etc/hostname << EOF
$HOSTNAME
EOF

