MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="//"

--//
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -ex

# User-supplied pre userdata code
${pre_userdata}

if [ ${format_mount_nvme_disk} = true ];then
echo "Format and Mount NVMe Disks if available"
IDX=1
DEVICES=$(lsblk -o NAME,TYPE -dsn | awk '/disk/ {print $1}')
for DEV in $DEVICES
do
  mkfs.xfs /dev/$${DEV}
  mkdir -p /local$${IDX}

  echo /dev/$${DEV} /local$${IDX} xfs defaults,noatime 1 2 >> /etc/fstab

  IDX=$(($${IDX} + 1))
done
mount -a
fi

# Install EKS nodegroup package (AL2023 specific)
dnf update -y
dnf install -y amazon-eks-nodegroup

# Initialize the node with nodeadm (AL2023 method)
/usr/bin/nodeadm init --cluster-name '${eks_cluster_id}' \
  --cluster-endpoint '${cluster_endpoint}' \
  --cluster-ca-data '${cluster_ca_base64}'

# User-supplied post userdata code
${post_userdata}

--//-- 