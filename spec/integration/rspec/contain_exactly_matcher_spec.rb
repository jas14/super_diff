require "spec_helper"

RSpec.describe "Integration with RSpec's #contain_exactly matcher",
               type: :integration do
  context "when a few number of values are given" do
    it "produces the correct failure message when used in the positive" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = ["Marty", "Jennifer", "Doc"]
          expected = ["Einie", "Marty"]
          expect(actual).to contain_exactly(*expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(actual).to contain_exactly(*expected)",
            expectation:
              proc do
                line do
                  plain "Expected "
                  actual %|["Marty", "Jennifer", "Doc"]|
                  plain " to contain exactly "
                  expected %|"Einie"|
                  plain " and "
                  expected %|"Marty"|
                  plain "."
                end
              end,
            diff:
              proc do
                plain_line "  ["
                plain_line %|    "Marty",|
                actual_line %|+   "Jennifer",|
                actual_line %|+   "Doc",|
                # expected_line %|-   "Einie"|  # TODO
                expected_line %|-   "Einie",|
                plain_line "  ]"
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it "produces the correct failure message when used in the negative" do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          values = ["Einie", "Marty"]
          expect(values).not_to contain_exactly(*values)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: "expect(values).not_to contain_exactly(*values)",
            expectation:
              proc do
                line do
                  plain "Expected "
                  actual %|["Einie", "Marty"]|
                  plain " not to contain exactly "
                  expected %|"Einie"|
                  plain " and "
                  expected %|"Marty"|
                  plain "."
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context "when a large number of values are given" do
    context "and they are only simple strings" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            actual = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expected = [
              "Doc Brown",
              "Marty McFly",
              "Biff Tannen",
              "George McFly",
              "Lorraine McFly"
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program =
            make_plain_test_program(snippet, color_enabled: color_enabled)

          expected_output =
            build_expected_output(
              color_enabled: color_enabled,
              snippet: "expect(actual).to contain_exactly(*expected)",
              expectation:
                proc do
                  line do
                    plain "          Expected "
                    actual %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
                  end

                  line do
                    plain "to contain exactly "
                    expected %|"Doc Brown"|
                    plain ", "
                    expected %|"Marty McFly"|
                    plain ", "
                    expected %|"Biff Tannen"|
                    plain ", "
                    expected %|"George McFly"|
                    plain " and "
                    expected %|"Lorraine McFly"|
                  end
                end,
              diff:
                proc do
                  plain_line "  ["
                  plain_line %|    "Marty McFly",|
                  plain_line %|    "Doc Brown",|
                  plain_line %|    "Lorraine McFly",|
                  actual_line %|+   "Einie",|
                  expected_line %|-   "Biff Tannen",|
                  # expected_line %|-   "George McFly"|  # TODO
                  expected_line %|-   "George McFly",|
                  plain_line "  ]"
                end
            )

          expect(program).to produce_output_when_run(expected_output).in_color(
            color_enabled
          )
        end
      end

      it "produces the correct failure message when used in the negative" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            values = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expect(values).not_to contain_exactly(*values)
          TEST
          program =
            make_plain_test_program(snippet, color_enabled: color_enabled)

          expected_output =
            build_expected_output(
              color_enabled: color_enabled,
              snippet: "expect(values).not_to contain_exactly(*values)",
              newline_before_expectation: true,
              expectation:
                proc do
                  line do
                    plain "              Expected "
                    actual %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
                  end

                  line do
                    plain "not to contain exactly "
                    expected %|"Marty McFly"|
                    plain ", "
                    expected %|"Doc Brown"|
                    plain ", "
                    expected %|"Einie"|
                    plain " and "
                    expected %|"Lorraine McFly"|
                  end
                end
            )

          expect(program).to produce_output_when_run(expected_output).in_color(
            color_enabled
          )
        end
      end
    end

    context "and some of them are regexen" do
      it "produces the correct failure message when used in the positive" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST
            actual = [
              "Marty McFly",
              "Doc Brown",
              "Einie",
              "Lorraine McFly"
            ]
            expected = [
              / Brown$/,
              "Marty McFly",
              "Biff Tannen",
              /Georg McFly/,
              /Lorrain McFly/
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program =
            make_plain_test_program(snippet, color_enabled: color_enabled)

          expected_output =
            build_expected_output(
              color_enabled: color_enabled,
              snippet: "expect(actual).to contain_exactly(*expected)",
              expectation:
                proc do
                  line do
                    plain "          Expected "
                    actual %|["Marty McFly", "Doc Brown", "Einie", "Lorraine McFly"]|
                  end

                  line do
                    plain "to contain exactly "
                    expected "/ Brown$/"
                    plain ", "
                    expected %|"Marty McFly"|
                    plain ", "
                    expected %|"Biff Tannen"|
                    plain ", "
                    expected "/Georg McFly/"
                    plain " and "
                    expected "/Lorrain McFly/"
                  end
                end,
              diff:
                proc do
                  plain_line "  ["
                  plain_line %|    "Marty McFly",|
                  plain_line %|    "Doc Brown",|
                  actual_line %|+   "Einie",|
                  actual_line %|+   "Lorraine McFly",|
                  expected_line %|-   "Biff Tannen",|
                  expected_line "-   /Georg McFly/,"
                  # expected_line %|-   /Lorrain McFly/|  # TODO
                  expected_line "-   /Lorrain McFly/,"
                  plain_line "  ]"
                end
            )

          expect(program).to produce_output_when_run(expected_output).in_color(
            color_enabled
          )
        end
      end

      it "produces the correct failure message when used in the negative" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST
            values = [
              / Brown$/,
              "Marty McFly",
              "Biff Tannen",
              /Georg McFly/,
              /Lorrain McFly/
            ]
            expect(values).not_to contain_exactly(*values)
          TEST
          program =
            make_plain_test_program(snippet, color_enabled: color_enabled)

          expected_output =
            build_expected_output(
              color_enabled: color_enabled,
              snippet: "expect(values).not_to contain_exactly(*values)",
              newline_before_expectation: true,
              expectation:
                proc do
                  line do
                    plain "              Expected "
                    actual %|[/ Brown$/, "Marty McFly", "Biff Tannen", /Georg McFly/, /Lorrain McFly/]|
                  end

                  line do
                    plain "not to contain exactly "
                    expected "/ Brown$/"
                    plain ", "
                    expected %|"Marty McFly"|
                    plain ", "
                    expected %|"Biff Tannen"|
                    plain ", "
                    expected "/Georg McFly/"
                    plain " and "
                    expected "/Lorrain McFly/"
                  end
                end
            )

          expect(program).to produce_output_when_run(expected_output).in_color(
            color_enabled
          )
        end
      end
    end

    context "and some of them are RSpec matchers" do
      it "produces the correct failure message" do
        as_both_colored_and_uncolored do |color_enabled|
          snippet = <<~TEST.strip
            actual = [
              { foo: "bar" },
              double(baz: "qux"),
              { blargh: "riddle" }
            ]
            expected = [
              a_hash_including(foo: "bar"),
              a_collection_containing_exactly("zing"),
              an_object_having_attributes(baz: "qux"),
            ]
            expect(actual).to contain_exactly(*expected)
          TEST
          program =
            make_plain_test_program(snippet, color_enabled: color_enabled)

          expected_output =
            build_expected_output(
              color_enabled: color_enabled,
              snippet: "expect(actual).to contain_exactly(*expected)",
              expectation:
                proc do
                  line do
                    plain "          Expected "
                    actual %|[{ foo: "bar" }, #<Double (anonymous) baz: "qux">, { blargh: "riddle" }]|
                  end

                  line do
                    plain "to contain exactly "
                    expected %|#<a hash including (foo: "bar")>|
                    plain ", "
                    expected %|#<a collection containing exactly ("zing")>|
                    plain " and "
                    expected %|#<an object having attributes (baz: "qux")>|
                  end
                end,
              diff:
                proc do
                  plain_line "  ["
                  plain_line "    {"
                  plain_line %|      foo: "bar"|
                  plain_line "    },"
                  plain_line "    #<Double (anonymous) {"
                  plain_line %|      baz: "qux"|
                  plain_line "    }>,"
                  actual_line "+   {"
                  actual_line %|+     blargh: "riddle"|
                  actual_line "+   },"
                  expected_line "-   #<a collection containing exactly ("
                  expected_line %|-     "zing"|
                  # expected_line %|-   )>|  # TODO
                  expected_line "-   )>,"
                  plain_line "  ]"
                end
            )

          expect(program).to produce_output_when_run(expected_output).in_color(
            color_enabled
          )
        end
      end
    end
  end
end
