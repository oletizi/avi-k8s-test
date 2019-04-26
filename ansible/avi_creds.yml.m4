avi_credentials:
  controller: "{{controller_ip}}"
  username: admin
  password: "{{password}}"
  api_version: 18.1.2

ew_subnet: "169.254.0.0"
ew_subnet_start: "169.254.0.2"
ew_subnet_end: "169.254.0.254"

ns_subnet: "__NS_SUBNET__"
ns_subnet_start: "__NS_SUBNET_START__"
ns_subnet_end: "__NS_SUBNET_END__"

project_name: "__PROJECT_NAME__"
kube_master_node: "__MASTER_NODE__:6443"
