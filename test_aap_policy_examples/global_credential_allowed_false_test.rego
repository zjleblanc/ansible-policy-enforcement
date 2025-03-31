package test_aap_policy_examples

import data.aap_policy_examples

test_global_credential_blocked if {
	test_input := {"credentials": [{
		"name": "global_cred",
		"organization": null,
	}]}
	aap_policy_examples.global_credential_allowed_false.allowed == false with input as test_input
}

test_global_credential_violation_message if {
	test_input := {"credentials": [{
		"name": "global_cred",
		"organization": null,
	}]}
	aap_policy_examples.global_credential_allowed_false.violations[0] == "Credential used in job execution does not belong to any org. Violating credentials: [global_cred]" with input as test_input
}

test_org_credential_allowed if {
	test_input := {"credentials": [{
		"name": "org_cred",
		"organization": "org1",
	}]}
	aap_policy_examples.global_credential_allowed_false.allowed == true with input as test_input
}

test_org_credential_no_violations if {
	test_input := {"credentials": [{
		"name": "org_cred",
		"organization": "org1",
	}]}
	count(aap_policy_examples.global_credential_allowed_false.violations) == 0 with input as test_input
}

test_multiple_credentials_mixed if {
	test_input := {"credentials": [
		{
			"name": "org_cred",
			"organization": "org1",
		},
		{
			"name": "global_cred",
			"organization": null,
		},
	]}
	aap_policy_examples.global_credential_allowed_false.allowed == false with input as test_input
}
