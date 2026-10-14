exclude :test_does_not_dump_system_schemas, "CockroachDB does not support DROP EXTENSION ... CASCADE."
exclude :test_dumps_schema_of_an_extension_that_dump_schemas_leaves_out, "CockroachDB does not support DROP EXTENSION ... CASCADE."
exclude :test_dumps_schema_once_when_dump_schemas_includes_it, "CockroachDB does not support DROP EXTENSION ... CASCADE."
