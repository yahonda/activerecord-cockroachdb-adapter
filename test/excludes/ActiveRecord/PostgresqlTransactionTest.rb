exclude :test_raises_LockWaitTimeout_when_lock_wait_timeout_exceeded, "The test tries to set lock_timeout, but lock_timeout is not supported by CockroachDB."
exclude :test_raises_QueryCanceled_when_canceling_statement_due_to_user_request, "CockroachDB doesn't support pg_cancel_backend()."
exclude :test_raises_Deadlocked_when_a_deadlock_is_encountered, "Causes CI to hand. Skip while debugging."
exclude :test_raises_SerializationFailure_when_a_serialization_failure_occurs, "Skipping until we can triage further. See https://github.com/cockroachdb/activerecord-cockroachdb-adapter/issues/48"

if ActiveRecord::Base.with_connection(&:database_version) < 25_01_00
  exclude :test_rolls_back_when_a_before_commit_callback_raises_a_rollback_error, "DO blocks are supported from CockroachDB v25.1."
end
