---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${eks_cluster_id}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthority: ${cluster_ca_base64}
    cidr: ${service_ipv4_cidr != "" ? service_ipv4_cidr : "172.20.0.0/16"}
%{ if kubelet_extra_args != "" }
  kubelet:
    flags:
      - ${kubelet_extra_args}
%{ endif }
%{ if pre_userdata != "" }
---
${pre_userdata}
%{ endif }
%{ if post_userdata != "" }
---
${post_userdata}
%{ endif } 