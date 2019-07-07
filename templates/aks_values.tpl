# Enter your Kubernetes provider. Replace "YOUR_KUBERNETES_PROVIDER" with one of the following values:
#   k8s - for a deployment using open-source Kubernetes
#   openshift - for a deployment using Red Hat Openshift
#   eks - for a deployment using Amazon EKS
#   gke - for a deployment using Google Kubernetes Engine
#   pks - for a deployment using Pivotal Container Service
#   aks - for a deployment using Azure Kubernetes Service
provider: "aks"

actions:
  # valid values are install, deploy, install-deploy
  # install - install the pega platform database.
  # deploy - deploy the full pega cluster
  # install-deploy - installation followed by full pega cluster deployment
  # upgrade - upgrades the pega platform to the build version.
  # upgrade-deploy - upgrades the pega platform and deploys the pega cluster on the upgraded database.
  execute: "install-deploy"

# Configure Traefik for load balancing:
#   If enabled: true, Traefik is deployed automatically.
#   If enabled: false, Traefik is not deployed and load balancing must be configured manually.
#   Pega recommends enabling Traefik on providers other than Openshift and eks.
#   On Openshift, Traefik is ignored and Pega uses Openshift's built-in load balancer.
#   On eks it is recommended to use aws alb ingress controller.
traefik:
  enabled: true
  # Set any additional Traefik parameters. These values will be used by Traefik's helm chart.
  # See https://github.com/helm/charts/blob/master/stable/traefik/values.yaml
  # Set traefik.serviceType to "LoadBalancer" on gke, aks, and pks
  serviceType: LoadBalancer
  # If enabled is set to "true", ssl will be enabled for traefik
  ssl:
    enabled: false
  rbac:
    enabled: true
  service:
    nodePorts:
      # NodePorts for traefik service.
      http: 30080
      https: 30443
  resources:
    requests:
      # Enter the CPU Request for traefik
      cpu: 200m
      # Enter the memory request for traefik
      memory: 200Mi
    limits:
      # Enter the CPU Limit for traefik
      cpu: 500m
      # Enter the memory limit for traefik
      memory: 500Mi

# Set this to true to install aws-alb-ingress-controller. Follow below guidelines specific to each provider,
# For EKS - set this to true.
# GKE or AKS or K8s or Openshift - set this to false and enable traefik.
aws-alb-ingress-controller:
  enabled: false
  ## Resources created by the ALB Ingress controller will be prefixed with this string
  clusterName: "YOUR_EKS_CLUSTER_NAME"
  ## Auto Discover awsRegion from ec2metadata, set this to true and omit awsRegion when ec2metadata is available.
  autoDiscoverAwsRegion: true
  ## AWS region of k8s cluster, required if ec2metadata is unavailable from controller pod
  ## Required if autoDiscoverAwsRegion != true
  awsRegion: "YOUR_EKS_CLUSTER_REGION"
  ## Auto Discover awsVpcID from ec2metadata, set this to true and omit awsVpcID: " when ec2metadata is available.
  autoDiscoverAwsVpcID: true
  ## VPC ID of k8s cluster, required if ec2metadata is unavailable from controller pod
  ## Required if autoDiscoverAwsVpcID != true
  awsVpcID: "YOUR_EKS_CLUSTER_VPC_ID"
  extraEnv:
    AWS_ACCESS_KEY_ID: "YOUR_AWS_ACCESS_KEY_ID"
    AWS_SECRET_ACCESS_KEY: "YOUR_AWS_SECRET_ACCESS_KEY"

# Docker image information for the Pega docker image, containing the application server.
# To use this feature you MUST host the image using a private registry.
# See https://kubernetes.io/docs/concepts/containers/images/#using-a-private-registry
# Note: the imagePullPolicy is always for all images in this deployment, so pre-pulling images will not work.
docker:
  installer:
    image: "systemmanagementteam/pega:installer-latest"
  pega:
    image: "systemmanagementteam/pega:web-latest"
  registry:
    url: "https://index.docker.io/v1/"
    # Provide your Docker registry username and password to access the docker image. These credentials will be
    # used for both the Pega Platform image and the Elasticsearch image.
    username: "YOUR_DOCKER_REGISTRY_USERNAME"
    password: "YOUR_DOCKER_REGISTRY_PASSWORD"

# JDBC information to connect to the Pega database.
# Pega must be installed to this database before deploying on Kubernetes.
#
# Examples for jdbc url and driver class:
# For Oracle:
#   url: jdbc:oracle:thin:@//YOUR_DB_HOST:1521/YOUR_DB_NAME
#   driverClass: oracle.jdbc.OracleDriver
# For Microsoft SQL Server:
#   url: jdbc:sqlserver://YOUR_DB_HOST:1433;databaseName=YOUR_DB_NAME;selectMethod=cursor;sendStringParametersAsUnicode=false
#   driverClass: com.microsoft.sqlserver.jdbc.SQLServerDriver
# For IBM DB2 for LUW:
#   url: jdbc:db2://YOUR_DB_HOST:50000/YOUR_DB_NAME:fullyMaterializeLobData=true;fullyMaterializeInputStreams=true;progressiveStreaming=2;useJDBC4ColumnNameAndLabelSemantics=2;
#   driverClass: com.ibm.db2.jcc.DB2Driver
# For IBM DB2 for z/OS:
#   url: jdbc:db2://YOUR_DB_HOST:50000/YOUR_DB_NAME
#   driverClass: com.ibm.db2.jcc.DB2Driver
# For PostgreSQL:
#   url: jdbc:postgresql://YOUR_DB_HOST:5432/YOUR_DB_NAME
#   driverClass: org.postgresql.Driver
# NOTE: These jdbc values provided are also considered for the upgrade source database details when upgrade/upgrade-deploy action is used.
jdbc:
  url: "YOUR_JDBC_URL"
  driverClass: "org.postgresql.Driver"
  # Set the database type only for action = install/install-deploy/upgrade/upgrade-deploy. Valid values are: mssql, oracledate, udb, db2zos, postgres
  dbType: "postgres"
  # Set the uri to download the database driver for your database.
  driverUri: "https://jdbc.postgresql.org/download/postgresql-42.2.5.jar"
  # Set your database username and password. These values will be obfuscated and stored in a secrets file.
  username: "postgres"
  password: "postgres"
  # Set your connection properties that will be sent to our JDBC driver when establishing new connections,Format of the string must be [propertyName=property;]
  connectionProperties: "socketTimeout=90"
  # Set the rules and data schemas for your database. Additional schemas can be defined within Pega.
  rulesSchema: "rules"
  dataSchema: "data"
  # If configured, set the customerdata schema for your database. Defaults to value of dataSchema if not provided.
  customerDataSchema: ""

# Customer specific information to customize the installation
installer:
  # Creates a new System and replaces this with default system.Default is pega
  systemName: "pega"
  # Creates the system with this production level.Default is 2
  productionLevel: 2
  # Whether this is a Multitenant System ('true' if yes, 'false' if no)
  multitenantSystem: "false"
  # UDF generation will be skipped if this property is set to true
  bypassUdfGeneration: "true"
  # Temporary password for administrator@pega.com that is used to install Pega Platform
  adminPassword: "install"
  # Run the Static Assembler ('true' to run, 'false' to not run)
  assembler:
  # Bypass automatically truncating PR_SYS_UPDATESCACHE . Default is false.
  bypassTruncateUpdatescache: "false"
  # JDBC custom connection properties
  jdbcCustomConnection: ""
  threads:
    # Maximum Idle Thread.Default is 5
    maxIdle: 5
    # Maximum Wait Thread.Default is -1
    maxWait: -1
    # Maximum Active Thread.Default is 10
    maxActive: 10
  zos:
    # Z/OS SITE-SPECIFIC PROPERTIES FILE
    zosProperties: "/opt/pega/config/DB2SiteDependent.properties"
    # Specify the workload manager to load UDFs into db2zos
    db2zosUdfWlm: ""
  # Upgrade specific properties
  upgrade:
    # Type of upgrade
    # Valid values are 'in-place' , 'out-of-place'
    upgradeType: "YOUR_UPGRADE_TYPE"
    # Specify target rules schema for migration and upgrade
    targetRulesSchema: "YOUR_TARGET_RULES_SCHEMA"
    # The commit count to use when loading database tables
    dbLoadCommitRate: 100
    # Update existing application will be run if this property is set to true
    updateExistingApplications: "false"
    # Runs the Update Applications Schema utility to update the cloned Rule, Data, Work and Work History tables with the schema changes in the latest base tables if this property is set to true
    updateApplicationsSchema: "false"
    # Generate and execute an SQL script to clean old rulesets and their rules from the system if this property is set to true
    runRulesetCleanup: "false"
    # Rebuild Database Rules Indexes after Rules Load to improve Database Access Performance
    rebuildIndexes: "false"
    # Configure only for aks/pks
    # Run "kubectl cluster-info" command to get the service host and https service port of kubernetes api server.
    # Example - Kubernetes master is running at https://<service_host>:<https_service_port>
    kube-apiserver:
      serviceHost: "API_SERVICE_ADDRESS"
      httpsServicePort: "SERVICE_PORT_HTTPS"

# Pega web deployment settings.
web:
  # Enter the domain name to access web nodes via a load balancer.
  #  e.g. web.mypega.example.com
  domain: "YOUR_WEB_NODE_DOMAIN"
  # Enter the number of web nodes for Kubernetes to deploy (minimum 1).
  replicas: 1
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each web node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each web node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each web node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each web node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options.
  javaOpts: ""
  # Initial heap size for the jvm.
  initialHeap: "4096m"
  # Maximum heap size for the jvm.
  maxHeap: "7168m"
  # Set your Pega diagnostic credentials.
  pegaDiagnosticUser: ""
  pegaDiagnosticPassword: ""
  # When provider is eks, configure alb cookie duration seconds equal to passivation time of requestors
  alb_stickiness_lb_cookie_duration_seconds: 3660
  deploymentStrategy:
    rollingUpdate:
      # Enter the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxSurge: 25%
      # Enter the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxUnavailable: 25%
    type: RollingUpdate
  hpa:
    # Pega supports autoscaling of pods in your deployment using the Horizontal Pod Autoscaler (HPA) of Kubernetes. For details, see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
    # Deployments of Pega Platform supports setting autoscaling thresholds based on CPU utilization and memory resources for a given pod in the deployment.
    # The recommended settings for CPU utilization and memory resource capacity thresholds are based on testing Pega application under heavy loads.
    # Customizing your thresholds to match your workloads will be based on your initial cpuRequest and memRequest web pod settings.
    enabled: true
    # Enter the minimum number of replicas that HPA can scale-down
    minReplicas: 1
    # Enter the maximum number of replicas that HPA can scale-up
    maxReplicas: 5
    # Enter the threshold value for average cpu utilization percentage.
    # Recommended value is 700% i.e. 1.4c (700% of 200m(recommended cpuRequest))
    # HPA will scale up if pega web pods average cpu utilization reaches 1.4c (based on Pega recommended values).
    targetAverageCPUUtilization: 700
    # Enter the threshold value for average memory utilization percentage.
    # Recommended value is 85% i.e. 5.1Gi (85% of 6Gi(recommended memRequest))
    # HPA will scale up if pega web pods average memory utilization reaches 5.1Gi (based on Pega recommended values).
    targetAverageMemoryUtilization: 85

# Pega stream deployment settings.
stream:
  # Enter the domain name to access stream nodes via a load balancer.
  #  e.g. stream.mypega.example.com
  domain: "YOUR_STREAM_NODE_DOMAIN"
  # Enter the number of stream nodes for Kubernetes to deploy (minimum 2).
  replicas: 2
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each stream node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each stream node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each stream node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each stream node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options
  javaOpts: ""
  # Initial heap size for the jvm
  initialHeap: "4096m"
  # Maximum heap size for the jvm
  maxHeap: "7168m"
  # When provider is eks, configure alb cookie duration seconds equal to passivation time of requestors
  alb_stickiness_lb_cookie_duration_seconds: 3660

# Pega batch deployment settings.
batch:
  # Enter the number of batch nodes for Kubernetes to deploy (minimum 1).
  replicas: 1
  # For an overview of setting CPU and memory resources, see https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/.
  # Enter the CPU request for each batch node (recommended 200m).
  cpuRequest: 200m
  # Enter the memory request for each batch node (recommended 6Gi).
  memRequest: "6Gi"
  # Enter the CPU limit for each batch node (recommended 2).
  cpuLimit: 2
  # Enter the memory limit for each batch node (recommended 8Gi).
  memLimit: "8Gi"
  # Enter any additional java options.
  javaOpts: ""
  # Initial heap size for the jvm.
  initialHeap: "4096m"
  # Maximum heap size for the jvm.
  maxHeap: "7168m"
  deploymentStrategy:
    rollingUpdate:
      # Enter the maximum number of Pods that can be unavailable during the update process. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxSurge: 25%
      # Enter the maximum number of Pods that can be created over the desired number of Pods. The value can be an absolute number (for example, 5) or a percentage of desired Pods (for example, 10%)
      maxUnavailable: 25%
    type: RollingUpdate
  hpa:
    # Pega supports autoscaling of pods in your deployment using the Horizontal Pod Autoscaler (HPA) of Kubernetes. For details, see https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
    # Deployments of Pega Platform supports setting autoscaling thresholds based on CPU utilization and memory resources for a given pod in the deployment.
    # The recommended settings for CPU utilization and memory resource capacity thresholds are based on testing Pega application under heavy loads.
    # Customizing your thresholds to match your workloads will be based on your initial cpuRequest and memRequest batch pod settings.
    enabled: true
    # Enter the minimum number of replicas that HPA can scale-down
    minReplicas: 1
    # Enter the maximum number of replicas that HPA can scale-up
    maxReplicas: 3
    # Enter the threshold value for average cpu utilization percentage.
    # Recommended value is 700% i.e. 1.4c (700% of 200m(recommended cpuRequest))
    # HPA will scale up if pega batch pods average cpu utilization reaches 1.4c (based on Pega recommended values).
    targetAverageCPUUtilization: 700
    # Enter the threshold value for average memory utilization percentage.
    # Recommended value is 85% i.e. 5.1Gi (80% of 6Gi(recommended memRequest))
    # HPA will scale up if pega batch pods average memory utilization reaches 5.1Gi (based on Pega recommended values).
    targetAverageMemoryUtilization: 85

# Cassandra automatic deployment settings.
cassandra:
  # Set cassandra.enabled to true to automatically deploy the Cassandra sub-chart.
  # Set to false if dds.externalNodes is set, or if you do not need Cassandra in your Pega environment.
  enabled: true
  # Set any additional Cassandra parameters. These values will be used by Cassandra's helm chart.
  # See https://github.com/helm/charts/blob/master/incubator/cassandra/values.yaml
  persistence:
    enabled: true

# DDS (external Cassandra) connection settings.
# These settings should only be modified if you are using a custom Cassandra deployment.
dds:
  # Enter an external node to use a custom external Cassandra deployment. If cassandra.enabled is set to true, leave dds.externalNodes blank.
  # If using an external node, cassandra.enabled should be set to false.
  # If dds.externalNodes is set and cassandra.enabled is set to true, Pega will connect to Cassandra using dds.externalNodes.
  externalNodes: ""
  # The port, username, and password should only be modified if supplying a custom external Cassandra node.
  port: "9042"
  username: "dnode_ext"
  password: "dnode_ext"

# Elasticsearch deployment settings.
# Note: This Elasticsearch deployment is used for Pega search, and is not the same Elasticsearch deployment used by the EFK stack.
# These search nodes will be deployed regardless of the Elasticsearch configuration above.
search:
  # Enter the number of search nodes for Kubernetes to deploy (minimum 1).
  replicas: 1
  # If externalURL is set, no search nodes will be deployed automatically, and Pega will use this search node url.
  externalURL: ""
  # Enter the docker image used to deploy Elasticsearch. This value will be ignored if using an external url.
  # Push the Elasticsearch image to your internal docker registry. This must be the same registry as the docker section above.
  image: "systemmanagementteam/pega:elasticsearch-latest"
  # Enter the CPU limit for each search node (recommended 1).
  cpuLimit: 1
  # Enter the volume size limit for each search node (recommended 5Gi).
  volumeSize: "5Gi"
  env:
    # IMPORTANT: https://www.elastic.co/guide/en/elasticsearch/reference/current/important-settings.html#minimum_master_nodes
    # To prevent data loss, it is vital to configure the discovery.zen.minimum_master_nodes setting so that each master-eligible
    # node knows the minimum number of master-eligible nodes that must be visible in order to form a cluster.
    # This value should be configured using formula (n/2) + 1 where n is replica count or desired capacity
    MINIMUM_MASTER_NODES: "1"

# Configure EFK stack for logging:
#   For a complete EFK stack: elasticsearch, fluentd-elasticsearch, and kibana should all be enabled
#   Pega recommends deploying EFK only on k8s
#   On Openshift, see https://docs.openshift.com/container-platform/3.11/install_config/aggregate_logging.html
#   On EKS, see https://eksworkshop.com/logging/

# Replace false with true to deploy EFK.
# Do not remove &deploy_efk; it is a yaml anchor which is referenced by the EFK subcharts.
deploy_efk: &deploy_efk false

elasticsearch:
  enabled: *deploy_efk
  # Set any additional elastic search parameters. These values will be used by elasticsearch helm chart.
  # See https://github.com/helm/charts/tree/master/stable/elasticsearch/values.yaml
  #
  # If you need to change this value then you will also need to replace the same
  # part of the value within the following properties further below:
  #
  #   kibana.files.kibana.yml.elasticsearch.url
  #   fluentd-elasticsearch.elasticsearch.host
  #
  fullnameOverride: "elastic-search"

kibana:
  enabled: *deploy_efk
  # Set any additional kibana parameters. These values will be used by Kibana's helm chart.
  # See https://github.com/helm/charts/tree/master/stable/kibana/values.yaml
  files:
    kibana.yml:
      elasticsearch.url: http://elastic-search-client:9200
  service:
    externalPort: 80
  ingress:
    # If enabled is set to "true", an ingress is created to access kibana.
    enabled: true
    # Enter the domain name to access kibana via a load balancer.
    hosts:
      - "YOUR_WEB.KIBANA.EXAMPLE.COM"

fluentd-elasticsearch:
  enabled: *deploy_efk
  # Set any additional fluentd-elasticsearch parameters. These values will be used by fluentd-elasticsearch's helm chart.
  # See https://github.com/helm/charts/tree/master/stable/fluentd-elasticsearch/values.yaml
  elasticsearch:
    host: elastic-search-client
    buffer_chunk_limit: 250M
    buffer_queue_limit: 30

metrics-server:
  # Set this to true to install metrics-server. Follow below guidelines specific to each provider,
  # open-source Kubernetes, Openshift & EKS - mandatory to set this to true if web.hpa.enabled or batch.hpa.enabled is true
  # GKE or AKS - set this to false since metrics-server is installed in the cluster by default.
  enabled: false
  # Set any additional metrics-server parameters. These values will be used by metrics-server's helm chart.
  # See https://github.com/helm/charts/blob/master/stable/metrics-server/values.yaml
  args:
  - --logtostderr
  # The order in which to consider different Kubelet node address types when connecting to Kubelet. Uncomment below arguemnt if host names are not resolvable from metrics server pod. This setting is not required for public cloud providers & openshift enterprise. It may be required for open-source Kubernetes.
  #- --kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP
  # Uncomment below arguemnt to skip verifying Kubelet CA certificates. Not recommended for production usage, but can be useful in test clusters with self-signed Kubelet serving certificates. This setting is not required for public cloud providers & openshift enterprise. It may be required for open-source Kubernetes.
  #- --kubelet-insecure-tls
