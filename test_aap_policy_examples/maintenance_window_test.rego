package test_aap_policy_examples

import data.aap_policy_examples

test_maintenance_window_allowed if {
	test_input := {"created": "2025-02-27T13:00:00Z"} # 13:00 UTC (within window)
	aap_policy_examples.maintenance_window.allowed == true with input as test_input
}

test_maintenance_window_blocked if {
	test_input := {"created": "2025-02-27T10:00:00Z"} # 10:00 UTC (outside window)
	aap_policy_examples.maintenance_window.allowed == false with input as test_input
}

test_maintenance_window_violation_message if {
	test_input := {"created": "2025-02-27T10:00:00Z"}
	aap_policy_examples.maintenance_window.violations[0] == "No job execution allowed outside of maintenance window" with input as test_input
}

test_maintenance_window_edge_case_start if {
	test_input := {"created": "2025-02-27T12:00:00Z"} # Exactly at start time
	aap_policy_examples.maintenance_window.allowed == true with input as test_input
}

test_maintenance_window_edge_case_end if {
	test_input := {"created": "2025-02-27T04:00:00Z"} # Exactly at end time
	aap_policy_examples.maintenance_window.allowed == true with input as test_input
}
