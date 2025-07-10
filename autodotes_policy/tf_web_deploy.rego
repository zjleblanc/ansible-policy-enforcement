package autodotes_policy

import rego.v1

# Define the allowed keys for extra_vars
allowed_extra_var_keys := ["az_ssh_pubkey", "az_web_vm_size"]
allowed_extra_var_values := {"az_web_vm_size": ["Standard_DS1_v2", "Standard_DS2_v2", "Standard_DS3_v2"]}

# Extract extra_vars
input_extra_vars := object.get(input, ["extra_vars"], {})

# Default policy result: allowed (no violations)
default tf_web_deploy := {
	"allowed": true,
	"violations": [],
}

# Evaluate extra_vars_allowlist, 
# checking if provided extra_vars contain any keys not allowed
tf_web_deploy := result if {
	violating_keys := [key | input_extra_vars[key]; not allowed_key(key)]
	count(violating_keys) > 0

	result := {
		"allowed": false,
		"violations": [sprintf("Following extra_vars are not allowed: %v. Allowed keys: %v", [violating_keys, allowed_extra_var_keys])],
	}
}

# Evaluate extra_vars_validation to check if extra_vars values are allowed
# Rules of same name are combined with logical OR
tf_web_deploy := result if {
	violating_keys := [key |
		allowed_extra_var_values[key]
		not allowed_value(key, input_extra_vars[key])
	]

	count(violating_keys) > 0

	result := {
		"allowed": false,
		"violations": [sprintf("🙅 extra_vars contain disallowed values for keys: %v. Allowed values: %v", [violating_keys, allowed_extra_var_values])],
	}
}

# Helper function: Checks if a given key is in the allowed_extra_var_keys list
allowed_key(key) if {
	allowed_extra_var_keys[_] == key
}

# Check if a given value for a key is allowed
allowed_value(key, value) if {
	allowed_extra_var_values[key][_] == value
}