package aap_policy_examples

default allow = true

violation_reason = "Credential used in job execution does not belong to any org"

# Find credentials with no organization
violating_credentials = {cred | cred := input.credential[_]; cred.organization == null}

# If any credential is violating, deny access and return violations
allowed = false {
    count(violating_credentials) > 0
}

violations = [violation_reason] {
    count(violating_credentials) > 0
}
