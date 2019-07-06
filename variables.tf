##################
# aws/gcp/azure  #
##################
variable cloud_provider {}

###############
# eks/gke/aks #
###############
variable kubernetes_provider {}

########################################
# region where the cluster is deployed #
########################################
variable region {}

#################################################################
# The dependency to wait for creating all  resources in module  #
#################################################################
variable wait_id {}

############################
# eks/aks/gke cluster name #
############################
variable name {}

###########################################
# Namespace where pega should be deployed #
###########################################
variable namespace {
  default = "pega"
}

###################################################
# HELM Release name where pega should be deployed #
###################################################
variable release_name {
  default = "pega"
}

###########################################
# HELM Chart name that should be deployed #
###########################################
variable chart_name {
  default = "pega"
}

##############################################
# HELM Chart version that should be deployed #
##############################################
variable chart_version {
  default = "pega"
}

########################################
# JDBC URL where the pega is installed #
########################################
variable jdbc_url {}

############################
# Database Username #
############################
variable jdbc_username {
  default = "postgres"
}

############################
# Database Password #
############################
variable jdbc_password {
  default = "postgres"
}

##############################################################
# The URL from where the pega helm charts will be downloaded #
##############################################################
variable pega_repo_url {
  default = "https://scrumteamwhitewalkers.github.io/pega-helm-charts/"
}

###################################################
# Docker URL from where the images will be pulled #
###################################################
variable docker_url {
  default = "https://index.docker.io/v1/"
}

############################
# Docker Registry Username #
############################
variable docker_username {}

############################
# Docker Registry Password #
############################
variable docker_password {}

###########################################################
# AWS Account access key only in the case of provider EKS #
###########################################################
variable aws_access_key_id {
  default = ""
}

##################################################################
# AWS Account secret access key only in the case of provider EKS #
##################################################################
variable aws_secret_access_key {
  default = ""
}

###########################################################################
# How much time the helm release should wait to install and deploy pega ? #
###########################################################################
variable deployment_timeout {
  default = "7200"
}

######################################################
# Shoud deploy Kubernetes Dashboard ?                #
# Will be true in case of EKS and AKS                #
# In GKE this can be enabled while creating cluster  #
######################################################
variable enable_kubernetes_dashboard {
  default = false
}

#################################
# Shoud deploy ALB Ingress ?    #
# Will be true in case of EKS?  #
#################################
variable enable_alb_ingress_controller {
  default = false
}

#####################################
# Shoud deploy cluster autoscaler ? #
# Will be true in case of EKS?      #
#####################################
variable enable_cluster_autoscaler {
  default = false
}

#################################
# Shoud deploy metrics server ? #
# Will be true in case of EKS?  #
#################################
variable enable_metrics_server {
  default = false
}

##############################
# Route53 Zone AWS Account ? #
##############################
variable route53_zone {
  default = "dev.pega.io"
}
