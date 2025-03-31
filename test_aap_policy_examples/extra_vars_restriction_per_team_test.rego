package test_aap_policy_examples

import data.aap_policy_examples
import rego.v1

# Test case: Empty extra_vars should be allowed
test_allow_empty_extra_vars if {
	test_input := {
		"extra_vars": {},
		"created_by": {"teams": [{"name": "dev_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == true with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == [] with input as test_input
}

# Test case: Dev team member should be allowed to use dev environment
test_allow_dev_team_dev_environment if {
	test_input := {
		"extra_vars": {"environment": "dev"},
		"created_by": {"teams": [{"name": "dev_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == true with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == [] with input as test_input
}

# Test case: Dev team member should be allowed to use staging environment
test_allow_dev_team_staging_environment if {
	test_input := {
		"extra_vars": {"environment": "staging"},
		"created_by": {"teams": [{"name": "dev_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == true with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == [] with input as test_input
}

# Test case: Prod team member should be allowed to use prod environment
test_allow_prod_team_prod_environment if {
	test_input := {
		"extra_vars": {"environment": "prod"},
		"created_by": {"teams": [{"name": "prod_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == true with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == [] with input as test_input
}

# Test case: Dev team member should not be allowed to use prod environment
test_reject_dev_team_prod_environment if {
	test_input := {
		"extra_vars": {"environment": "prod"},
		"created_by": {"teams": [{"name": "dev_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == false with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == ["extra_vars contain disallowed values for keys: [\"environment\"]. Allowed extra_vars for your teams ({\"dev_team\"}): {\"dev_team\": {\"environment\": [\"dev\", \"staging\"]}}"] with input as test_input
}

# Test case: Prod team member should not be allowed to use dev environment
test_reject_prod_team_dev_environment if {
	test_input := {
		"extra_vars": {"environment": "dev"},
		"created_by": {"teams": [{"name": "prod_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == false with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == ["extra_vars contain disallowed values for keys: [\"environment\"]. Allowed extra_vars for your teams ({\"prod_team\"}): {\"prod_team\": {\"environment\": [\"prod\", \"staging\"]}}"] with input as test_input
}

# Test case: User in multiple teams should have access to environments from all teams
test_allow_multiple_teams_environment if {
	test_input := {
		"extra_vars": {"environment": "staging"},
		"created_by": {"teams": [{"name": "dev_team"}, {"name": "prod_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == true with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == [] with input as test_input
}

# Test case: Non-team member should not be allowed to use any environment
test_reject_non_team_member if {
	test_input := {
		"extra_vars": {"environment": "dev"},
		"created_by": {"teams": [{"name": "other_team"}]},
	}
	aap_policy_examples.extra_vars_restriction_per_team.allowed == false with input as test_input
	aap_policy_examples.extra_vars_restriction_per_team.violations == ["extra_vars contain disallowed values for keys: [\"environment\"]. Allowed extra_vars for your teams ({\"other_team\"}): {}"] with input as test_input
}
