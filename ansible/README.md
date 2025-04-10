# OPA Server Deployment Playbook

This Ansible playbook deploys an OpenPolicyAgent (OPA) server on OpenShift with mTLS support and provides tools for loading and managing OPA policies.

> ⚠️ **Warning: Development and Testing Only**
> 
> This OPA server deployment is designed for development and testing purposes only. Please note:
> - Policies loaded onto this OPA server are non-persistent
> - If the OPA pod restarts, all loaded policies will be lost
> - You will need to reload policies after any pod restart
> - This setup is not suitable for production use
> 
> For production deployments, please refer to the [official OPA documentation](https://www.openpolicyagent.org/docs/latest/deployment/)

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Deploying OPA Server](#deploying-opa-server)
  - [Loading OPA Policies](#loading-opa-policies)
- [mTLS Support](#mtls-support)
- [Accessing OPA Server](#accessing-opa-server-via-openshift-route)
  - [Basic Health Check](#basic-health-check)
  - [Policy Validation](#validating-policy-loading)

## Prerequisites

- Ansible 2.9+
- OpenShift CLI (oc)
- Access to an OpenShift cluster
- Python kubernetes module (`pip install kubernetes`)
- Python cryptography module (`pip install cryptography`)
- OpenSSL

## Installation

1. Install the required Ansible collections:

```bash
ansible-galaxy collection install -r requirements.yml
```

## Configuration

The playbook can be configured by modifying the variables in `roles/opa/defaults/main.yml` or by creating a custom vars file in `vars/main.yml`.

Key configuration options:

- `opa_namespace`: Namespace where OPA will be deployed
- `opa_image`: OPA container image to use
- `certificates_dir`: Directory for storing generated certificates
- `kubeconfig`: Path to your kubeconfig file (defaults to `~/.kube/config` or `K8S_AUTH_KUBECONFIG` environment variable)
- `create_route`: Whether to create an OpenShift route (default: `true`)

## Usage

### Deploying OPA Server

1. Set your kubeconfig path in one of these ways:
   - Set the `K8S_AUTH_KUBECONFIG` environment variable to the file path of your KUBECONFIG file
   - Set `kubeconfig` variable to the file path of your KUBECONFIG file
   - Create a custom vars file with your `kubeconfig` path

2. Run the deployment playbook:

```bash
ansible-playbook deploy-opa-mtls.yml
```

### Loading OPA Policies

To load policies onto your OPA server, use the provided playbook:

```bash
ansible-playbook load-opa-policies-mtls.yml
```

This playbook will:
- Load all policies from the repository onto your OPA server
- Use mTLS for secure communication with the OPA server
- Configure the policies using variables defined in `vars/main.yml`

## mTLS Support

The playbook automatically:

1. Generates a CA certificate and key
2. Generates server certificates and keys
3. Generates client certificates and keys
4. Creates a Kubernetes secret with the certificates
5. Configures the OPA server to use mTLS

The certificates will be stored in the directory specified by `certificates_dir` (default: `certificates/` in the playbook directory).

## Accessing OPA Server via OpenShift Route

The OPA server is exposed externally through an OpenShift route. To access it using curl:

1. Get the route URL:
```bash
oc get route opa-mtls -n opa -o jsonpath='{.spec.host}'
```

### Basic Health Check

```bash
curl --cacert certificates/ca.crt \
     --cert certificates/client.crt \
     --key certificates/client.key \
     https://$(oc get route opa-mtls -n opa -o jsonpath='{.spec.host}')/health
```

### Validating Policy Loading

To validate that the policies were loaded successfully, you can use the following commands with your mTLS certificates:

1. List all loaded policies:
```bash
curl --cacert certificates/ca.crt \
     --cert certificates/client.crt \
     --key certificates/client.key \
     https://$(oc get route opa-mtls -n opa -o jsonpath='{.spec.host}')/v1/policies | jq
```

2. Test a specific policy:
```bash
curl --cacert certificates/ca.crt \
     --cert certificates/client.crt \
     --key certificates/client.key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"input": {"example": "test"}}' \
     https://$(oc get route opa-mtls -n opa -o jsonpath='{.spec.host}')/v1/data/aap_policy_examples/allowed_false
```

Replace `aap_policy_examples/allowed_false` and the input data with the specific policy and test data you want to validate.
