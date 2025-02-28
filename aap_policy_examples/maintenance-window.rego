package app_policy_examples

# Define maintenance window in EST (UTC-5)
maintenance_start_hour = 17  # 5 PM EST
maintenance_end_hour = 9     # 9 AM EST
utc_offset = 5               # EST is UTC-5

# Extract the job creation timestamp (which is in UTC)
job_created = input.created
created_hour_utc = time.hour(time.parse_rfc3339_ns(job_created))

# Convert UTC hour to EST
created_hour_est = (created_hour_utc - utc_offset) mod 24

# Check if job was created within the maintenance window (EST)
is_maintenance_time {
    created_hour_est >= maintenance_start_hour  # After 5 PM EST
}

is_maintenance_time {
    created_hour_est < maintenance_end_hour  # Before 9 AM EST
}

# Default allow policy
default allow := true

allow {
    not is_maintenance_time
}

# Generate violation message when denied
violations := ["No job execution allowed outside of maintenance window"] {
    not is_maintenance_time
}
