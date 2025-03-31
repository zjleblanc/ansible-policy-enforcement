package test_aap_policy_examples

import data.aap_policy_examples

test_allowed_false_always_false if {
	aap_policy_examples.allowed_false.allowed == false
}

test_allowed_false_has_violation if {
	aap_policy_examples.allowed_false.violations[0] == "No job execution is allowed"
}

test_allowed_false_single_violation if {
	count(aap_policy_examples.allowed_false.violations) == 1
}
