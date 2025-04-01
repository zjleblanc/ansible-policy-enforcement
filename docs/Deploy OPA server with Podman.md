# Quick Start Guide

This guide will help you set up and run the OPA (Open Policy Agent) server using Podman for use with Ansible Automation Platform (AAP). **This setup is intended for testing and development purposes only.**

## ⚠️ Security Warning

This setup runs an OPA server with:
- No authentication (AuthN)
- No authorization (AuthZ)
- No TLS/HTTPS
- No access controls

**DO NOT use this configuration in production environments.** This setup is designed for local development and testing only.

## Prerequisites

- Podman installed on your system
- Make installed on your system
- Network connectivity between your AAP instance and the OPA server

## Running OPA Server with Podman

1. First, ensure that your OPA server will be accessible from your AAP instance. The OPA server needs to be reachable via HTTP/HTTPS.

2. Run the OPA server using Podman:

```bash
make container/run-opa-server
```

This command will:
- Run the OPA server in a Podman container
- Make the server accessible on port 8181
- Mount your policies directory (`aap_policy_examples`) into the container
- Enable file watching for automatic policy updates
- Use the latest OPA version by default

## Verifying the Setup

1. Test the OPA server's health endpoint:
```bash
curl http://localhost:8181/health
```

You should receive a response indicating the server is healthy.

## Important Notes

- Make sure your AAP instance can reach the OPA server's address and port
- This setup is for development and testing purposes only
- For production environments, you must:
  - Implement proper authentication
  - Configure authorization controls
  - Enable HTTPS/TLS
  - Set up appropriate firewall rules
  - Consider using a reverse proxy
  - Implement proper access controls

For more detailed information about OPA configuration and policy management, refer to the [official OPA documentation](https://www.openpolicyagent.org/docs/latest/). 