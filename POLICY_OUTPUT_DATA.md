# Expected output from OPA policy evaluation

This document describes the expected output from OPA policy query

## Expected Fields

### `allowed`
- **Type:** Boolean
- **Description:** Indicates whether the action is permitted.

### `violations`
- **Type:** List of Strings
- **Description:** Reasons why the action is not allowed.

## Example output expected from OPA policy query

```json
{
  "allowed": false,
  "violations": [
    "No job execution is allowed",
    ...
  ],
  ...
}
```
