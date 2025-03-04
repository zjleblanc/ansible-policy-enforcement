# Example policy and use cases

Directory contains various example and use cases that will guild you through how to use policy as code feature in Ansible Automation Platform

## Prereqs

- An Ansible Ansible Automation Platform 2.5 deployment with the `FEATURE_POLICY_AS_CODE_ENABLED` feature flag set to `True`
- An OPA server that's reachable from your Ansible Automation Platform deployment
- Configured Ansible Automation Platform with settings required for authenticating to your OPA server. For more detail see "Setting up Policy as Code for Ansible Automation Platform"
- `opa` client installed and general knowledge around OPA and the Rego language .

## Index

1. Prevent job execution at various policy enforcement points.
2. Prevent job execution by platform admin.
3. Prevent job execution during maintenance window.
4. Prevent job execution using credential with no Organization.
5. Prevent job execution using mismatching resources.
6. Prevent job execution from untrusted SCM source.
8. ...
