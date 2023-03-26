module SuperDiff
  module IntegrationTests
    module TestPrograms
      class RSpecActiveSupport < Base
        protected

        def test_plan_prelude
          <<~PRELUDE.strip
            test_plan.boot
            test_plan.boot_active_support
          PRELUDE
        end

        def test_plan_command
          "run_rspec_active_support_test"
        end
      end
    end
  end
end
