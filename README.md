# Forgeops on Big Sur

Kleine Anleitung zur Installation von `forgeops` auf
macOS Big Sur

## Adminuser vergessen

Das neue OS BigSur, vergisst wer Adminuser ist. Virtualbox lässt sich nicht
installieren. Dies Anleitung hilft, das Problem zu fixen.

https://appletoolbox.com/cant-enter-your-password-in-macos-big-sur-heres-how-to-fix-it/

## Installation der Software

Homebrew installieren

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

VSCodium installieren

    $ brew install --cask vscodium

Git installieren

    $ brew install git
    $ git config --global user.name "Patrick Schlaepfer"
    $ git config --global user.email patrick@schlaepfer.com

Das Script `setupforgeops.sh` laufen lassen.

### Minikube ip/name verlinken

Run the minikube ip command to get the Minikube ingress controller’s IP address:

    $ minikube ip
    111.222.33.44

Add an entry similar to the following to the /etc/hosts file:

    minikube-ip-address my-namespace.iam.example.

### Docker Repo

Set Up Your Local Computer to Use Minikube’s Docker Engine
Run the docker-env command in your shell:

    $ eval $(minikube docker-env)
    $ skaffold config set --kube-context minikube local-cluster true

### Sourcen von forgeops clonen

    $ git clone https://github.com/ForgeRock/forgeops.git
    $ cd forgeops
    $ git checkout tags/2020.08.07-ZucchiniRicotta.1 -b my-branch

### Deploy the ForgeRock Identity Platform

Change the deployment namespace for the all environment from the default namespace to your namespace:

Change to the directory containing the all environment:

    $ cd /path/to/forgeops/kustomize/overlay/7.0/all
    $ vi kustomization.yaml file.

Modify two lines in the file so that the platform is deployed in your namespace:

| Original Text        | Revised Text | 
| ------------- | ------------- |
| namespace: default | namespace: my-namespace |
| FQDN: default.iam.example.com | FQDN: my-namespace.iam.example.com |

Save the updated kustomization.yaml file.

Initialize the staging area for configuration profiles with the canonical CDK configuration profile for the ForgeRock Identity Platform:

    $ cd /path/to/forgeops/bin
    $ ./config.sh init --profile cdk --version 7.0

### amster Dockerfile

forgeops/docker/7.0/amster/Dockerfile

`RUN apt-get update` hinzufügen.

```
FROM gcr.io/forgerock-io/amster:7.0.0
  
USER root
RUN apt-get update
RUN apt-get install -y openldap-utils jq
USER forgerock

ENV SERVER_URI /am

COPY --chown=forgerock:root . /opt/amster

ENTRYPOINT [ "/opt/amster/docker-entrypoint.sh" ]
```

### Run Skaffold to build Docker images and deploy the ForgeRock Identity Platform:

    $ cd /path/to/forgeops
    $ skaffold run

Nun kann mit `k9s` das Deployment überwacht werden. mit dem 
Kommando `ns:` in `my-namespace` wechseln.

Es braucht etwas Zeit für das Deployment

    - my-namespace:deployment/am is ready.
    Deployments stabilized in 5m25.295664293s

### Access the AM Console

Obtain the amadmin user’s password:

    $ cd /path/to/forgeops/bin
    $ ./print-secrets.sh amadmin

Open a new window or tab in a web browser.

Go to https://my-namespace.iam.example.com/platform.

The Kubernetes ingress controller handles the request, routing it to the login-ui pod.

The login UI prompts you to log in.

Log in as the amadmin user.

