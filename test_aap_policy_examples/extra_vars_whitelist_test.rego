package test_aap_policy_examples

import data.aap_policy_examples
import rego.v1

# Test case: Empty extra_vars should be allowed
test_allow_empty_extra_vars if {
	aap_policy_examples.extra_vars_whitelist.allowed == true
	aap_policy_examples.extra_vars_whitelist.violations == []
}

# Test case: Allowed extra_vars key should be allowed
test_allow_valid_extra_vars if {
	test_input := {"extra_vars": {"allowed": "some_value"}}
	aap_policy_examples.extra_vars_whitelist.allowed == true with input as test_input
	aap_policy_examples.extra_vars_whitelist.violations == [] with input as test_input
}

# Test case: Disallowed extra_vars key should be rejected
test_reject_disallowed_extra_vars if {
	test_input := {"extra_vars": {"disallowed": "some_value"}}
	aap_policy_examples.extra_vars_whitelist.allowed == false with input as test_input
	aap_policy_examples.extra_vars_whitelist.violations == ["Following extra_vars are not allowed: [\"disallowed\"]. Allowed keys: [\"allowed\"]"] with input as test_input
}

# Test case: Multiple disallowed extra_vars keys should be rejected
test_reject_multiple_disallowed_extra_vars if {
	test_input := {"extra_vars": {"disallowed1": "value1", "disallowed2": "value2"}}
	aap_policy_examples.extra_vars_whitelist.allowed == false with input as test_input
	aap_policy_examples.extra_vars_whitelist.violations == ["Following extra_vars are not allowed: [\"disallowed1\", \"disallowed2\"]. Allowed keys: [\"allowed\"]"] with input as test_input
}

# Test case: Mix of allowed and disallowed keys should be rejected
test_reject_mixed_extra_vars if {
	test_input := {"extra_vars": {"allowed": "value1", "disallowed": "value2"}}
	aap_policy_examples.extra_vars_whitelist.allowed == false with input as test_input
	aap_policy_examples.extra_vars_whitelist.violations == ["Following extra_vars are not allowed: [\"disallowed\"]. Allowed keys: [\"allowed\"]"] with input as test_input
}
