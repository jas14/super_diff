# frozen_string_literal: true

module SuperDiff
  module Csi
    class ResetSequence
      def to_s
        "\e[0m"
      end
    end
  end
end
