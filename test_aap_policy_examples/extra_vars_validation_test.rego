package test_aap_policy_examples

import data.aap_policy_examples
import rego.v1

# Test case: Empty extra_vars should be allowed
test_allow_empty_extra_vars if {
	aap_policy_examples.extra_vars_validation.allowed == true
	aap_policy_examples.extra_vars_validation.violations == []
}

# Test case: Valid extra_vars value should be allowed
test_allow_valid_extra_vars if {
	test_input := {"extra_vars": {"extra_var_key": "allowed_value1"}}
	aap_policy_examples.extra_vars_validation.allowed == true with input as test_input
	aap_policy_examples.extra_vars_validation.violations == [] with input as test_input
}

# Test case: Another valid extra_vars value should be allowed
test_allow_another_valid_extra_vars if {
	test_input := {"extra_vars": {"extra_var_key": "allowed_value2"}}
	aap_policy_examples.extra_vars_validation.allowed == true with input as test_input
	aap_policy_examples.extra_vars_validation.violations == [] with input as test_input
}

# Test case: Invalid extra_vars value should be rejected
test_reject_invalid_extra_vars if {
	test_input := {"extra_vars": {"extra_var_key": "invalid_value"}}
	aap_policy_examples.extra_vars_validation.allowed == false with input as test_input
	aap_policy_examples.extra_vars_validation.violations == ["extra_vars contain disallowed values for keys: [\"extra_var_key\"]. Allowed values: {\"extra_var_key\": [\"allowed_value1\", \"allowed_value2\"]}"] with input as test_input
}

# Test case: Non-whitelisted key should be allowed (since it's not in valid_extra_var_values)
test_allow_non_whitelisted_key if {
	test_input := {"extra_vars": {"other_key": "any_value"}}
	aap_policy_examples.extra_vars_validation.allowed == true with input as test_input
	aap_policy_examples.extra_vars_validation.violations == [] with input as test_input
}

# Test case: Multiple valid extra_vars should be allowed
test_allow_multiple_valid_extra_vars if {
	test_input := {"extra_vars": {"extra_var_key": "allowed_value1", "other_key": "any_value"}}
	aap_policy_examples.extra_vars_validation.allowed == true with input as test_input
	aap_policy_examples.extra_vars_validation.violations == [] with input as test_input
}
