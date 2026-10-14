exclude :test_comparison_expression_preserves_infinite_range_bounds, "The CockroachDB adapter quotes every numeric literal (see quoting.rb, CVE-2022-44566), so the SQL has floor('1.0') instead of floor(1.0)."
exclude :test_batch_cursors_use_query_predicate_expressions, "Primary keys default to unique_rowid(), which does not fit the 4-byte InvertedInteger type used by the test."
exclude :test_implicit_order_uses_query_predicate_expressions, "Primary keys default to unique_rowid(), which does not fit the 4-byte InvertedInteger type used by the test."
