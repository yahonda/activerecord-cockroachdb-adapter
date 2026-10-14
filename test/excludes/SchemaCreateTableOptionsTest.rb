exclude :test_multiple_inherited_table_options_is_dumped, "INHERITS keyword unsupported. See https://go.crdb.dev/issue-v/22456/v24.3"
exclude :test_inherited_table_options_is_dumped, "INHERITS keyword unsupported. See https://go.crdb.dev/issue-v/22456/v24.3"
exclude :test_inherited_table_options_from_a_schema_off_the_search_path_is_dumped, "CockroachDB does not support table inheritance."
exclude :test_table_options_are_only_read_for_base_tables, "CockroachDB does not support COMMENT ON VIEW, which the test runs in its setup."
