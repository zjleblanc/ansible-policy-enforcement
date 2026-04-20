package test_autodotes_policy

import data.autodotes_policy
import rego.v1

test_non_production_without_ticket_allowed if {
	test_input := {"extra_vars": {
		"target_environment": "staging",
		"operation": "apply_migration",
	}}
	r := autodotes_policy.demo_database_maintenance with input as test_input
	r.allowed == true
	r.violations == []
}

test_production_with_valid_ticket_allowed if {
	test_input := {"extra_vars": {
		"target_environment": "production",
		"change_ticket": "CHG-4412",
		"operation": "apply_migration",
	}}
	r := autodotes_policy.demo_database_maintenance with input as test_input
	r.allowed == true
	r.violations == []
}

test_production_without_ticket_denied if {
	test_input := {"extra_vars": {
		"target_environment": "production",
		"operation": "apply_migration",
	}}
	r := autodotes_policy.demo_database_maintenance with input as test_input
	r.allowed == false
	count(r.violations) == 1
	some v in r.violations
	contains(v, "production change control")
	contains(v, "change_ticket")
}

test_production_with_bad_ticket_denied if {
	test_input := {"extra_vars": {
		"target_environment": "prod",
		"change_ticket": "INC-123",
	}}
	r := autodotes_policy.demo_database_maintenance with input as test_input
	r.allowed == false
	some v in r.violations
	contains(v, "INC-123")
	contains(v, "CHG-")
}
