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

###

Run the minikube ip command to get the Minikube ingress controller’s IP address:

    $ minikube ip
    111.222.33.44

Add an entry similar to the following to the /etc/hosts file:

    nminikube-ip-address my-namespace.iam.example.

### Sourcen von forgeops clonen

    $ git clone https://github.com/ForgeRock/forgeops.git
    $ cd forgeops
    $ git checkout tags/2020.08.07-ZucchiniRicotta.1 -b my-branch

## amster Dockerfile

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

