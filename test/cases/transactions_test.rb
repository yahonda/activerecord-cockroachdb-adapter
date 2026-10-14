# frozen_string_literal: true

require "cases/helper_cockroachdb"

module CockroachDB
  class TransactionsTest < ActiveRecord::TestCase
    self.use_transactional_tests = false

    class Avenger < ActiveRecord::Base
      singleton_class.attr_accessor :cyclic_barrier, :attempts

      validate :validate_unique_username

      def validate_unique_username
        self.class.attempts.increment
        duplicate = self.class.where(name: name).any?
        # Every thread reads the table before any of them inserts, so the
        # transactions conflict and CockroachDB makes all but one retry.
        # Retries skip the barrier.
        self.class.cyclic_barrier.wait(10) if Thread.current[:first_attempt]
        Thread.current[:first_attempt] = false
        errors.add("Duplicate username!") if duplicate
      end
    end

    def setup
      @conn = ActiveRecord::Base.lease_connection
      @conn.create_table :avengers, force: true do |t|
        t.string :name
      end
    end

    def teardown
      @conn.drop_table :avengers, if_exists: true
    end

    def test_concurrent_insert_with_processes # corrupting #1
      avengers = %w[Hulk Thor Loki]
      Avenger.cyclic_barrier = Concurrent::CyclicBarrier.new(avengers.size)
      Avenger.attempts = Concurrent::AtomicFixnum.new
      Thread.current[:name] = "Main" # For debug logs.

      avengers.map do |name|
        Thread.fork do
          Thread.current[:name] = name # For debug logs.
          Thread.current[:first_attempt] = true
          Avenger.create!(name: name)
        end
      end.each(&:join)

      assert_operator Avenger.attempts.value, :>, avengers.size, "expected at least one transaction to be retried"
      assert_equal avengers.size, Avenger.count
    ensure
      Thread.current[:name] = nil
    end
  end
end
