package aap_policy_examples

import rego.v1

violations contains msg if {
	input.created_by.is_superuser == true
	msg := "SuperUser is not allow to launch jobs"
}

superuser_allowed_false := {
	"allowed": count(violations) == 0,
	"violations": violations,
}
