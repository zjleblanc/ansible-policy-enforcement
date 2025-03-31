package test_aap_policy_examples

import data.aap_policy_examples

test_superuser_blocked if {
	test_input := {"created_by": {"is_superuser": true}}
	aap_policy_examples.superuser_allowed_false.allowed == false with input as test_input
}

test_superuser_violation_message if {
	test_input := {"created_by": {"is_superuser": true}}
	aap_policy_examples.superuser_allowed_false.violations[0] == "SuperUser is not allow to launch jobs" with input as test_input
}

test_non_superuser_allowed if {
	test_input := {"created_by": {"is_superuser": false}}
	aap_policy_examples.superuser_allowed_false.allowed == true with input as test_input
}

test_non_superuser_no_violations if {
	test_input := {"created_by": {"is_superuser": false}}
	count(aap_policy_examples.superuser_allowed_false.violations) == 0 with input as test_input
}
