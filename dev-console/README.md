# Introduction 

MVP for a newfeed App hosted in the Azure cloud

Implementation details:

- The App is build from 3 micro services hosted in Azure Managed Kubernetes Service ( AKS)

front-end
newsfeed
quotes 

- Newsfeed front-end is exposed via Azure LB and accepts HTTP reqs on port 8080 
- Static content used by the app is served by a Azure Storage Account configured to serve static web content


- All the cloud infra is deployed using IaC ( terraform) 

- Current CI/CD automation  is achieved through the use of GNU Make/bash scripts
# Getting Started

The project has 3 base modules , that can be setup in a mono or multirepo , depending on how many people will develop and contribute to the several areas

mvpapp                  - Holds the apps codebase plus Dockerfiles and k8s manifests
cloud-infrastructure    - Holds all the Terraform codebase
dev-console             - Holds teh codebase that allows for all automation for the project 

1.	Installation process

    - clone the project repo or donwload the tarball file
    - Edit the template  env config files - env.bash.template -  under each module,replace the appropriate values with your specific env details an save the file bash  :

            mvpapp/shim/env.bash
            cloud-infrastructure/shim/env.bash
            dev-console/shim/env.bash
    
    - 
    
    - run make in the root of dev-console

2.	Software dependencies

    - this project was developed in WSL2 running and Ubuntu-20.04 Ditribution
    - run 'make check' in teh source of dev-console to check teh tool/binaries needed to build/test/deploy the infra and the app


# Build and Test
 
  - The Apps can be builded and tested by running 'make build-artifacts' 

   NOTE: For now only unit tests are supported. E2e test with docker images running in local kind cluster to come !

# Deploy
    - Run 'make full'

# TODO
    Devops
    - Configuration values are currently being configured via environment variables , the idea will be to switch to CI/CD pipelines using CI tools / Jenkins, Github actions...
    - Include configurations for deployment of the container images locally in a kind cluster, so that e2e smoke testing can be executed - they could them be used as a gate in PR approval
    
    Infra
     - The service is currently exposing a HTTP EP , which is insecure. Migrate from k8s public load balancer to ingress-controller with TLS termination , will require also a domain and a  certificate . Possibility is to use cert-manager for cert management and lets-encrypt 
      - All the Azure infra resources need to be hardened 
             AKS API server is currently public - Although Auth is in place , the endpoint is still exposed to DDOS attacks
             ACR , KV and SA also are publicly exposes - SHoudld run with private link/private EP
     - Obervability/Monitoring is still missing : one possibility would be to use Elastic+Kibana for logs , metrics and APM
            