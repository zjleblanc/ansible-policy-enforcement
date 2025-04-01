# Configuring OPA Server Connection in Ansible Automation Platform

After enabling the Policy as Code feature, you can configure the connection to your OPA server through the AAP user interface. This document describes how to set up the OPA server connection.

## Accessing Policy Settings

1. Log in to your Ansible Automation Platform web interface as System Admin
2. Navigate to **Settings** in the left navigation menu
3. Select **Policy** from the settings submenu
4. Click the **Edit** button in the top right corner to modify the policy settings

## Available Configuration Options

### Basic Settings

- **OPA server hostname**: The hostname of your OPA server
  - Example: `opa-awx.apps.controller-dev.testing.ansible.com`
  - If left empty, policy enforcement will be disabled

- **OPA server port**: The port number on which the OPA server is listening
  - Default: `8181`

- **OPA authentication type**: The authentication method to use when connecting to OPA
  - Available options: 
    - `None`: No authentication
    - `Token`: Bearer token authentication
    - `Certificate`: Client certificate (mTLS) authentication

### Authentication Settings

#### Token Authentication
When **OPA authentication type** is set to `Token`:
- **OPA authentication token**: The bearer token used for authentication

Note: If custom headers include an authorization header, it will be overridden by this token

#### Certificate Authentication
When **OPA authentication type** is set to `Certificate`:
- **OPA client certificate content**: The content of the client certificate file for mTLS authentication
- **OPA client key content**: The content of the client private key for mTLS authentication
- **OPA CA certificate content**: The content of the CA certificate for mTLS authentication

Note: All three certificate fields are required for certificate authentication

### Advanced Settings

- **OPA request timeout**: The timeout duration for OPA requests in seconds
  - Default: `1.5`

- **OPA request retry count**: Number of times to retry failed OPA requests
  - Default: `2`

### Security Options

- **Use SSL for OPA connection**: Enable/disable SSL for secure communication
  - Default: `Disabled`

### Custom Headers

- **OPA custom authentication headers**: Optional custom headers for authentication
  - Format: YAML or JSON
  - Default: Empty dictionary (`{}`)

Note: If using token authentication, any authorization header here will be overridden by the token setting

## After Configuration

Once you have configured these settings:
1. Save your changes using the Save button
2. The system will validate the connection to your OPA server
3. If successful, AAP will begin using this OPA server for policy decisions

## Troubleshooting

If you encounter connection issues:
1. Verify the hostname and port are correct
2. Ensure the OPA server is accessible from your AAP instance
3. Check if any firewalls are blocking the connection
4. Verify SSL settings if enabled
5. Review the authentication configuration:
   - For token authentication: Verify the token is valid and properly formatted
   - For certificate authentication: Ensure all certificate and key contents are properly provided
   - For custom headers: Verify the YAML/JSON format is correct 