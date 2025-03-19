# Input data for OPA policy from job execution

This document describes the input data that Ansible Automation Platform will provide to OPA server when querying policies

## Fields

### `id`
- **Type:** Integer
- **Description:** Unique identifier for the job.

### `name`
- **Type:** String
- **Description:** Name of the job template.

### `created`
- **Type:** Datetime (ISO 8601)
- **Description:** Timestamp indicating when the job was created.

### `created_by`
- **Type:** Object
- **Description:** Information about the user who created the job.
  - `id` (Integer): Unique identifier for the user.
  - `username` (String): Username of the creator.
  - `is_superuser` (Boolean): Indicates if the user is a superuser.

### `credentials`
- **Type:** List of Objects
- **Description:** Credentials associated with the job execution.
  - `id` (Integer): Unique identifier for the credential.
  - `name` (String): Name of the credential.
  - `description` (String): Description of the credential.
  - `organization` (Integer or Null): Organization identifier associated with the credential.
  - `credential_type` (Integer): Type identifier for the credential.
  - `managed` (Boolean): Indicates if the credential is managed internally.
  - `kind` (String): Credential type (`ssh`, `cloud`, `kubernetes`, etc.).
  - `cloud` (Boolean): Indicates if the credential is for cloud services.
  - `kubernetes` (Boolean): Indicates if the credential is for Kubernetes services.

### `execution_environment`
- **Type:** Object
- **Description:** Details about the execution environment used for the job.
  - `id` (Integer): Unique identifier for the execution environment.
  - `name` (String): Name of the execution environment.
  - `image` (String): Container image used for execution.
  - `pull` (String): Pull policy for the execution environment.

### `extra_vars`
- **Type:** JSON
- **Description:** Extra variables provided for the job execution.

### `forks`
- **Type:** Integer
- **Description:** Number of parallel processes used for the job execution.

### `hosts_count`
- **Type:** Integer
- **Description:** Number of hosts targeted by the job.

### `instance_group`
- **Type:** Object
- **Description:** Information about the instance group handling the job.
  - `id` (Integer): Unique identifier for the instance group.
  - `name` (String): Name of the instance group.
  - `capacity` (Integer): Available capacity in the group.
  - `jobs_running` (Integer): Number of currently running jobs.
  - `jobs_total` (Integer): Total jobs handled by the group.
  - `max_concurrent_jobs` (Integer): Maximum concurrent jobs allowed.
  - `max_forks` (Integer): Maximum forks allowed.

### `inventory`
- **Type:** Object
- **Description:** Inventory details used in the job execution.
  - `id` (Integer): Unique identifier for the inventory.
  - `name` (String): Name of the inventory.
  - `description` (String): Description of the inventory.
  - `kind` (String): Inventory type.
  - `total_hosts` (Integer): Total number of hosts in the inventory.
  - `total_groups` (Integer): Total number of groups in the inventory.
  - `has_inventory_sources` (Boolean): Indicates if the inventory has external sources.
  - `total_inventory_sources` (Integer): Number of external inventory sources.
  - `has_active_failures` (Boolean): Indicates if there are active failures in the inventory.
  - `hosts_with_active_failures` (Integer): Number of hosts with active failures.
  - `inventory_sources` (Array): External inventory sources associated with the inventory.

### `job_template`
- **Type:** Object
- **Description:** Information about the job template.
  - `id` (Integer): Unique identifier for the job template.
  - `name` (String): Name of the job template.
  - `job_type` (String): Type of job (e.g., `run`).

### `job_type`
- **Type:** Choice (String)
- **Description:** Type of job execution.
  - Allowed values:
    - `run`: Run
    - `check`: Check
    - `scan`: Scan

### `job_type_name`
- **Type:** String
- **Description:** Human-readable name for the job type.

### `labels`
- **Type:** List of Objects
- **Description:** Labels associated with the job.
  - `id` (Integer): Unique identifier for the label.
  - `name` (String): Name of the label.
  - `organization` (Object): Organization associated with the label.
    - `id` (Integer): Unique identifier of the organization.
    - `name` (String): Name of the organization.

### `launch_type`
- **Type:** Choice (String)
- **Description:** How the job was launched.
  - Allowed values:
    - `manual`: Manual
    - `relaunch`: Relaunch
    - `callback`: Callback
    - `scheduled`: Scheduled
    - `dependency`: Dependency
    - `workflow`: Workflow
    - `webhook`: Webhook
    - `sync`: Sync
    - `scm`: SCM Update

### `limit`
- **Type:** String
- **Description:** Limit applied to the job execution.

### `launched_by`
- **Type:** Object
- **Description:** Information about the user who launched the job.
  - `id` (Integer): Unique identifier for the user.
  - `name` (String): Name of the user.
  - `type` (String): Type of user (`user`, `system`, etc.).
  - `url` (String): API URL for the user.

### `organization`
- **Type:** Object
- **Description:** Information about the organization associated with the job.
  - `id` (Integer): Unique identifier for the organization.
  - `name` (String): Name of the organization.

### `playbook`
- **Type:** String
- **Description:** The playbook used in the job execution.

### `project`
- **Type:** Object
- **Description:** Details about the project associated with the job.
  - `id` (Integer): Unique identifier for the project.
  - `name` (String): Name of the project.
  - `status` (Choice - String): Status of the project.
    - `successful`: Successful
    - `failed`: Failed
    - `error`: Error
  - `scm_type` (String): Source control type (`git`, `svn`, etc.).
  - `scm_url` (String): URL of the source control repository.
  - `scm_branch` (String): Branch used in the repository.
  - `scm_refspec` (String): RefSpec for the repository.
  - `scm_clean` (Boolean): Whether SCM is cleaned before updates.
  - `scm_track_submodules` (Boolean): Whether submodules are tracked.
  - `scm_delete_on_update` (Boolean): Whether SCM deletes files on update.

### `scm_branch`
- **Type:** String
- **Description:** Specific branch to use for SCM.

### `scm_revision`
- **Type:** String
- **Description:** SCM revision used for the job.

### `workflow_job`
- **Type:** Object
- **Description:** Workflow job details, if the job is part of a workflow.
  - `id` (Integer): Unique identifier for the workflow job.
  - `name` (String): Name of the workflow job.

### `workflow_job_template`
- **Type:** Object
- **Description:** Workflow job template details.
  - `id` (Integer): Unique identifier for the workflow job template.
  - `name` (String): Name of the workflow job template.
  - `job_type` (String or Null): Type of job within the workflow context.

## Example input data from demo job template launch

```json
{
  "id": 70,
  "name": "Demo Job Template",
  "created": "2025-03-19T19:07:03.329426Z",
  "created_by": {
    "id": 1,
    "username": "admin",
    "is_superuser": true,
    "teams": []
  },
  "credentials": [
    {
      "id": 3,
      "name": "Example Machine Credential",
      "description": "",
      "organization": null,
      "credential_type": 1,
      "managed": false,
      "kind": "ssh",
      "cloud": false,
      "kubernetes": false
    }
  ],
  "execution_environment": {
    "id": 2,
    "name": "Default execution environment",
    "image": "registry.redhat.io/ansible-automation-platform-25/ee-supported-rhel8@sha256:b9f60d9ebbbb5fdc394186574b95dea5763b045ceff253815afeb435c626914d",
    "pull": ""
  },
  "extra_vars": {
    "example": "value"
  },
  "forks": 0,
  "hosts_count": 0,
  "instance_group": {
    "id": 2,
    "name": "default",
    "capacity": 0,
    "jobs_running": 1,
    "jobs_total": 38,
    "max_concurrent_jobs": 0,
    "max_forks": 0
  },
  "inventory": {
    "id": 1,
    "name": "Demo Inventory",
    "description": "",
    "kind": "",
    "total_hosts": 1,
    "total_groups": 0,
    "has_inventory_sources": false,
    "total_inventory_sources": 0,
    "has_active_failures": false,
    "hosts_with_active_failures": 0,
    "inventory_sources": []
  },
  "job_template": {
    "id": 7,
    "name": "Demo Job Template",
    "job_type": "run"
  },
  "job_type": "run",
  "job_type_name": "job",
  "labels": [
    {
      "id": 1,
      "name": "Demo label",
      "organization": {
        "id": 1,
        "name": "Default"
      }
    }
  ],
  "launch_type": "workflow",
  "limit": "",
  "launched_by": {
    "id": 1,
    "name": "admin",
    "type": "user",
    "url": "/api/v2/users/1/"
  },
  "organization": {
    "id": 1,
    "name": "Default"
  },
  "playbook": "hello_world.yml",
  "project": {
    "id": 6,
    "name": "Demo Project",
    "status": "successful",
    "scm_type": "git",
    "scm_url": "https://github.com/ansible/ansible-tower-samples",
    "scm_branch": "",
    "scm_refspec": "",
    "scm_clean": false,
    "scm_track_submodules": false,
    "scm_delete_on_update": false
  },
  "scm_branch": "",
  "scm_revision": "",
  "workflow_job": {
    "id": 69,
    "name": "Demo Workflow"
  },
  "workflow_job_template": {
    "id": 10,
    "name": "Demo Workflow",
    "job_type": null
  }
}
```
