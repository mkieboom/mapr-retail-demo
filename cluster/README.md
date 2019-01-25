# mapr-retail-demo cluster configuration

#### Disclaimer
Not for production use and not officially supported.
Ansible scripts work on Redhat/CentOS 7.x only.

#### Pre-requisites
```
yum install -y git ansible
```

##### Clone the project
```
git clone https://github.com/mkieboom/mapr-retail-demo
cd mapr-retail-demo/cluster/
```

#### Configuration
Specify the below configuration parameters
```
vi group_vars/all
```

#### Node Configuration
Specify the node IP addresses or hostnames in the appropriate myhosts file, eg:
```
vi myhosts/1node_cluster
```

#### Launch Ansible scripts:
Execute the Ansible scripts to prepare the MapR cluster:
```
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i myhosts/1node_cluster mapr-retail-demo.yml
```

#### Supported OS

* Redhat 7 or higher
* CentOS 7 or higher
