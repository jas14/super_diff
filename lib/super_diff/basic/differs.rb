module SuperDiff
  module Basic
    module Differs
      autoload :Array, "super_diff/basic/differs/array"
      autoload :CustomObject, "super_diff/basic/differs/custom_object"
      autoload :DateLike, "super_diff/basic/differs/date_like"
      autoload :RangeObject, "super_diff/basic/differs/range_object"
      autoload :DefaultObject, "super_diff/basic/differs/default_object"
      autoload :Hash, "super_diff/basic/differs/hash"
      autoload :MultilineString, "super_diff/basic/differs/multiline_string"
      autoload :TimeLike, "super_diff/basic/differs/time_like"

      class Main
        def self.call(*args)
          warn <<~EOT
            WARNING: SuperDiff::Differs::Main.call(...) is deprecated and will be removed in the next major release.
            Please use SuperDiff.diff(...) instead.
            #{caller_locations.join("\n")}
          EOT
          SuperDiff.diff(*args)
        end
      end
    end
  end
end
