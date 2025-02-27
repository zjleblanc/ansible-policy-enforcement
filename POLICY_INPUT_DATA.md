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
- **Type:** Integer
- **Description:** Identifier for the inventory used in the job.

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

### `workflow_job_id`
- **Type:** Integer or Null
- **Description:** Identifier for the associated workflow job, if applicable.

### `workflow_node_id`
- **Type:** Integer or Null
- **Description:** Identifier for the associated workflow node, if applicable.

### `workflow_job_template`
- **Type:** Object or Null
- **Description:** Information about the workflow job template, if applicable.

## Example input data from demo job template launch

```json
{
  "id": 785,
  "name": "Demo Job Template",
  "created": "2025-02-27T20:32:14.874821Z",
  "created_by": {
    "id": 1,
    "username": "admin",
    "is_superuser": true
  },
  "execution_environment": {
    "id": 2,
    "name": "Default execution environment",
    "image": "registry.redhat.io/ansible-automation-platform-25/ee-supported-rhel8:latest",
    "pull": ""
  },
  "extra_vars": {},
  "forks": 0,
  "hosts_count": 0,
  "instance_group": {
    "id": 2,
    "name": "default",
    "capacity": 134,
    "jobs_running": 1,
    "jobs_total": 209,
    "max_concurrent_jobs": 0,
    "max_forks": 0
  },
  "inventory": 1,
  "job_template": {
    "id": 7,
    "name": "Demo Job Template",
    "job_type": "run"
  },
  "job_type": "run",
  "job_type_name": "job",
  "launch_type": "manual",
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
  "workflow_job_id": null,
  "workflow_node_id": null,
  "workflow_job_template": null
}
```
