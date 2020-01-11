pipeline {
  agent none
  options { skipDefaultCheckout(false) }
  stages {
    stage('Build & Deploy Project') {
      agent any
      stages {
        stage('Build') {
        steps {
          scmSkip(deleteBuild: true, skipPattern:'.*\\[ci skip\\].*')
          sh '''echo "Build Process started .."

# Install unzip
yum -y install unzip git

# Setup Packer
rm -rf packer*
wget https://releases.hashicorp.com/packer/1.4.4/packer_1.4.4_linux_amd64.zip
unzip packer_1.4.4_linux_amd64.zip
mv packer* /usr/sbin/

# Setup Terraform
rm -rf terraform*
wget https://releases.hashicorp.com/terraform/0.12.10/terraform_0.12.10_linux_amd64.zip
unzip terraform_0.12.10_linux_amd64.zip
mv terraform* /usr/bin/

# Git clone
cat > ~/.ssh/msaqibhashmi-ssh-key << EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxD6OTdb6ckJ934Z06WWkw7iJ66M/Z9vIDvkxD6lQtK7FW994
YmfF3GD/EuWEZvS4MaYWMel+v88OUdn6gmAhoFJk4zMbkZSFmdMpzbUTV2T0zSLm
isEnVD2dqX/OBjPgd23p6FhMMTx/X0T6IQUVbwhkLv1ijL7IUkbSzz6WQgEQl2f+
TYVkAkQalqi9k/+RrD6slXECdhFEK0HYfPk0sw45YxKw/OB8pGfQMGmph4nPH6Gj
WHmpbgtFYdgMhkpWJfQtIzXvPF9bqsA59Fgcj0nQ7MpbZVMdV/4uKsML0H7G+Cit
+Nljaj0nw7H0wse8Y6V/LLdfzdyi+lOynDq93wIDAQABAoIBAQCoJp3SjsEcBGNM
ky48Cq8KUWZENSYQPN8IDXd/XunbV+Gd3jaNwzNjqO0G6QjxGwF08UYVUGgdvDId
6nPfILXPZKozj0gxDp0HeEtaiqxe9w9Xcm8uN2EWqpEcenkzEWJlkxWY04e9rIPL
QxQ8FNoPwJXvOYgm5xZIgY0CrTMcq8KnpzQuIldMTTdpc1Vi+ScD3Q5f6UKmhrkO
VCbZBsR6Xis3F0VYQfe8gzQb2vrhj+lLSuOxFT0G2ihq/5kH38GxwozieKpZgdsV
2wReQG8a6ylblq7KgWsYsbr+/QxeFDeuI1xu/2dybI2zBAi5BzAnNb+HIzT1++7J
h0eLVJ+ZAoGBAOYoXu9FcmF0J1Lpr6307d/mpQdyKhZq7QbxEs3gRtr6/f5qY/4Z
FQ7UI3qaopUVuVLIAwXwyAruDJPLSK3BGGwL5ZuwAVVjX/t6kAGzqJO3k4dK+279
SpBOu4qBtJI5Zz98gcdQ817unCqA/nycrFrLv+JAy8f4EpveKEMSQHGTAoGBANpH
YizTjewzShm1W5K2jub2yOxkZGa8WsAydc6btGGjFK+r1RPSRzy2hOAIBDgiDxeu
zACgsDprhTtp9zcXwrRJh/+N52cjo1XQTpbqR2VgxqqKMrIjrXoRAtXp1kgMjTKi
AB+ZK3NiybQWy96I7unsOeuVmIpNvuHtIIMwcSIFAoGAajd1YI03NTxqrXwFRI3F
fdAulxobzE66Zrq4x+RaLtMohtJIpUqkCjzixsE4iP8GkOqXYpV1bH3htg9Z0j5L
7AkthMUcSHDdKeytKuvjv5A3+HclRFqGn8SGDmy/jcAKIyVtqzNzrXsG/SKcz5tq
e1iOjHcE1Jtq0x4ajKGOthsCgYEAq+c99SmjAtsdx4Nhm/i0MEc405r4y0QZgHX8
+3r6o05I81SzWYnoWnMv0DPgBskj87XQqcnjIA8ffTwl2riWuV+TgHqkPED/2IxV
6FqXYcrGivaNmGeqrpCJGCixfkqMRMz6pef+JUAus+qkIhzbc1R8BQHqgTlbVBho
24iiAHUCgYB/8vjFOjEDOFR+s1+nrTkWZkI91yXqavBlNN9NfD1ge8UKiirvhWr2
q0PkivGafWQReX4qx40hyF/ut82UUwSZyoYPcql3ZBJTThXZv2Dc0/RfSsZ5Wxvc
UOdcpkAK4p681TKJMc5xWrRqiKBGFmpQfklxFns68EAvys8Gu6oXSw==
-----END RSA PRIVATE KEY-----
EOF

chmod 400 ~/.ssh/msaqibhashmi-ssh-key
eval `ssh-agent`
ssh-add ~/.ssh/msaqibhashmi-ssh-key
ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts

cd /root/
git clone git@bitbucket.org:gaditek-saqibhashmi/atom-monitoring.git

cd /root/atom-monitoring/
git checkout demo
ls
$(which python) /root/atom-monitoring/version_manager.py
git add build_versions.txt
git commit -m "[ci skip] build_versions.txt updated with latest release"
git push origin demo

cd /root/atom-monitoring/packer/
packer build packer.json
'''
      }
    }
    stage('Deploy') {
      steps {
        sh '''cd /root/atom-monitoring/terraform/
terraform init
terraform apply -auto-approve
'''
      }
    }
  }
  post {
    always {
      sh '''yum -y remove unzip
rm -rf /usr/local/sbin/packer
rm -rf /usr/local/bin/terraform
rm -rf /root/atom-monitoring
rm -rf ~/.ssh/msaqibhashmi-ssh-key
echo > ~/.ssh/known_hosts
echo "Cleaning Completed...!!"'''
    }

    success {
      sh '''echo "Pipeline completed successfully...!!"'''
    }

    unstable {
      echo 'Pipeline is unstable :/'
    }

    failure {
      echo 'Pipeline failed :('
    }
    changed {
      echo 'Things were different before...'
        }
      }
    }
  }
}

