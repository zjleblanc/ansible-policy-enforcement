# Quick Start Guide

This guide will help you set up and run the OPA (Open Policy Agent) server on OpenShift Container Platform (OCP) for use with Ansible Automation Platform (AAP). **This setup is intended for testing and development purposes only.**

## ⚠️ Security Warning

This setup runs an OPA server with:
- No authentication (AuthN)
- No authorization (AuthZ)
- No TLS/HTTPS
- No access controls

**DO NOT use this configuration in production environments.** This setup is designed for development and testing only.

## Prerequisites

- OpenShift CLI (`oc`) installed and configured
- Access to an OpenShift cluster with appropriate permissions
- Network connectivity between your AAP instance and the OPA server
- Make installed on your system

## Running OPA Server on OpenShift

1. First, ensure that your OPA server will be accessible from your AAP instance. The OPA server needs to be reachable via HTTP/HTTPS.

2. Create a new project for OPA (optional, but recommended):
```bash
oc new-project opa-server
```

3. Deploy the OPA server using the provided OpenShift manifests:
```bash
make openshift/deploy-opa-server
```

This command will:
- Create necessary OpenShift resources (Deployment, Service, Route)
- Mount your policies directory (`aap_policy_examples`) into the container
- Enable file watching for automatic policy updates
- Use the latest OPA version by default
- Create a Route for external access

## Verifying the Setup

1. Get the OPA server's route URL:
```bash
oc get route opa -o jsonpath='{.spec.host}'
```

2. Test the OPA server's health endpoint:
```bash
curl http://$(oc get route opa -o jsonpath='{.spec.host}')/health
```

You should receive a response indicating the server is healthy.

## Loading Policies

The OPA server is configured to automatically load policies from the mounted `aap_policy_examples` directory. However, you can also manually load or update policies using the provided make target.

1. Load all policies from the `aap_policy_examples` directory:
```bash
make openshift/load-policies
```

This command will:
- Get the OPA server's route URL
- Load all `.rego` files from the `aap_policy_examples` directory
- Verify that each policy was loaded successfully

2. To verify a specific policy was loaded, you can use:
```bash
make openshift/verify-policy POLICY_NAME=your-policy-name
```

## Important Notes

- Make sure your AAP instance can reach the OPA server's route URL
- This setup is for development and testing purposes only
- For production environments, you must:
  - Implement proper authentication
  - Configure authorization controls
  - Enable HTTPS/TLS
  - Set up appropriate network policies
  - Consider using a reverse proxy
  - Implement proper access controls
  - Configure resource limits and requests
  - Set up proper monitoring and logging

For more detailed information about OPA configuration and policy management, refer to the [official OPA documentation](https://www.openpolicyagent.org/docs/latest/). 