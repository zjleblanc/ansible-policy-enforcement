# OPA Server Deployment Playbook

This Ansible playbook deploys an OpenPolicyAgent (OPA) server on OpenShift with mTLS support.

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

1. Set your kubeconfig path in one of these ways:
   - Set the `K8S_AUTH_KUBECONFIG` environment variable to the file path of your KUBECONFIG file
   - Set `kubeconfig` variable to the file path of your KUBECONFIG file
   - Create a custom vars file with your `kubeconfig` path

2. Run the playbook:

```bash
ansible-playbook deploy-opa-mtls.yml
```

## mTLS Support

The playbook automatically:

1. Generates a CA certificate and key
2. Generates server certificates and keys
3. Generates client certificates and keys
4. Creates a Kubernetes secret with the certificates
5. Configures the OPA server to use mTLS

The certificates will be stored in the directory specified by `certificates_dir` (default: `certificates/` in the playbook directory).

### Accessing  OPA Server via OpenShift Route

The OPA server is exposed externally through an OpenShift route. To access it using curl:

1. Get the route URL:
```bash
oc get route opa-mtls -n opa -o jsonpath='{.spec.host}'
```

2. Use curl with the client certificates (generated in the `certificates/` directory):
```bash
# Basic health check
curl --cacert certificates/ca.crt \
     --cert certificates/client.crt \
     --key certificates/client.key \
     https://$(oc get route opa-mtls -n opa -o jsonpath='{.spec.host}')/health

# Query a policy
curl --cacert certificates/ca.crt \
     --cert certificates/client.crt \
     --key certificates/client.key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"input": {"user": "alice"}}' \
     https://$(oc get route opa-mtls -n opa -o jsonpath='{.spec.host}')/v1/data/package/rule
```
