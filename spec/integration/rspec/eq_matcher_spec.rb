# frozen_string_literal: true

require 'spec_helper'

RSpec.describe "Integration with RSpec's #eq matcher", type: :integration do
  context 'when comparing two different integers' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = 'expect(1).to eq(42)'
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: snippet,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '1'
                  plain ' to eq '
                  expected '42'
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = 'expect(42).not_to eq(42)'
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: snippet,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '42'
                  plain ' not to eq '
                  expected '42'
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two different symbols' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = 'expect(:bar).to eq(:foo)'
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: snippet,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual ':bar'
                  plain ' to eq '
                  expected ':foo'
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = 'expect(:foo).not_to eq(:foo)'
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: snippet,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual ':foo'
                  plain ' not to eq '
                  expected ':foo'
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two single-line strings' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = %|expect("Jennifer").to eq("Marty")|
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect("Jennifer").to eq("Marty")|,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %("Jennifer")
                  plain ' to eq '
                  expected %("Marty")
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = %|expect("Jennifer").not_to eq("Jennifer")|
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: %|expect("Jennifer").not_to eq("Jennifer")|,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %("Jennifer")
                  plain ' not to eq '
                  expected %("Jennifer")
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two different Time instances' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~RUBY
          actual = Time.utc(2011, 12, 13, 14, 15, 16)
          expected = Time.utc(2011, 12, 13, 14, 15, 16, 500_000)
          expect(actual).to eq(expected)
        RUBY
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '#<Time 2011-12-13 14:15:16 +00:00 (UTC)>'
                end

                line do
                  plain '   to eq '
                  expected '#<Time 2011-12-13 14:15:16+(1/2) +00:00 (UTC)>'
                end
              end,
            diff:
              proc do
                plain_line '  #<Time {'
                plain_line '    year: 2011,'
                plain_line '    month: 12,'
                plain_line '    day: 13,'
                plain_line '    hour: 14,'
                plain_line '    min: 15,'
                plain_line '    sec: 16,'
                expected_line '-   subsec: (1/2),'
                actual_line '+   subsec: 0,'
                plain_line '    zone: "UTC",'
                plain_line '    utc_offset: 0'
                plain_line '  }>'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~RUBY
          time = Time.utc(2011, 12, 13, 14, 15, 16)
          expect(time).not_to eq(time)
        RUBY
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(time).not_to eq(time)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual '#<Time 2011-12-13 14:15:16 +00:00 (UTC)>'
                end

                line do
                  plain 'not to eq '
                  expected '#<Time 2011-12-13 14:15:16 +00:00 (UTC)>'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two different Date instances' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~RUBY
          actual = Date.new(2023, 10, 14)
          expected = Date.new(2023, 10, 31)
          expect(actual).to eq(expected)
        RUBY
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '#<Date 2023-10-14>'
                  plain ' to eq '
                  expected '#<Date 2023-10-31>'
                  plain '.'
                end
              end,
            diff:
              proc do
                plain_line '  #<Date {'
                plain_line '    year: 2023,'
                plain_line '    month: 10,'
                expected_line '-   day: 31'
                actual_line '+   day: 14'
                plain_line '  }>'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~RUBY
          date = Date.new(2023, 10, 14)
          expect(date).not_to eq(date)
        RUBY
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(date).not_to eq(date)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '#<Date 2023-10-14>'
                  plain ' not to eq '
                  expected '#<Date 2023-10-14>'
                  plain '.'
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing a single-line string with a multi-line string' do
    it 'produces the correct failure message' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = "This is a line\\nAnd that's another line\\n"
          expected = "Something entirely different"
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %("This is a line\\nAnd that's another line\\n")
                  plain ' to eq '
                  expected %("Something entirely different")
                  plain '.'
                end
              end,
            diff:
              proc do
                expected_line '- Something entirely different'
                actual_line %(+ This is a line\\n)
                actual_line %(+ And that's another line\\n)
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing a multi-line string with a single-line string' do
    it 'produces the correct failure message' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = "Something entirely different"
          expected = "This is a line\\nAnd that's another line\\n"
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %("Something entirely different")
                  plain ' to eq '
                  expected %("This is a line\\nAnd that's another line\\n")
                  plain '.'
                end
              end,
            diff:
              proc do
                expected_line %(- This is a line\\n)
                expected_line %(- And that's another line\\n)
                actual_line '+ Something entirely different'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two multi-line strings' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = "This is a line\\nSomething completely different\\nAnd there's a line too\\n"
          expected = "This is a line\\nAnd that's a line\\nAnd there's a line too\\n"
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %("This is a line\\nSomething completely different\\nAnd there's a line too\\n")
                end

                line do
                  plain '   to eq '
                  expected %("This is a line\\nAnd that's a line\\nAnd there's a line too\\n")
                end
              end,
            diff:
              proc do
                plain_line %(  This is a line\\n)
                expected_line %(- And that's a line\\n)
                actual_line %(+ Something completely different\\n)
                plain_line %(  And there's a line too\\n)
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          string = "This is a line\\nAnd that's a line\\nAnd there's a line too\\n"
          expect(string).not_to eq(string)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(string).not_to eq(string)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual %("This is a line\\nAnd that's a line\\nAnd there's a line too\\n")
                end

                line do
                  plain 'not to eq '
                  expected %("This is a line\\nAnd that's a line\\nAnd there's a line too\\n")
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two arrays with other data structures inside' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST
          actual = [
            [
              :h2,
              [:span, [:text, "Goodbye world"]],
              {
                id: "hero",
                class: "header",
                data: {
                  "sticky" => false,
                  role: "deprecated",
                  person: SuperDiff::Test::Person.new(name: "Doc", age: 60)
                }
              }
            ],
            :br
          ]
          expected = [
            [
              :h1,
              [:span, [:text, "Hello world"]],
              {
                class: "header",
                data: {
                  "sticky" => true,
                  person: SuperDiff::Test::Person.new(name: "Marty", age: 60)
                }
              }
            ]
          ]
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %([[:h2, [:span, [:text, "Goodbye world"]], { id: "hero", class: "header", data: { "sticky" => false, :role => "deprecated", :person => #<SuperDiff::Test::Person name: "Doc", age: 60> } }], :br])
                end

                line do
                  plain '   to eq '
                  expected %([[:h1, [:span, [:text, "Hello world"]], { class: "header", data: { "sticky" => true, :person => #<SuperDiff::Test::Person name: "Marty", age: 60> } }]])
                end
              end,
            diff:
              proc do
                plain_line '  ['
                plain_line '    ['
                expected_line '-     :h1,'
                actual_line '+     :h2,'
                plain_line '      ['
                plain_line '        :span,'
                plain_line '        ['
                plain_line '          :text,'
                expected_line %(-         "Hello world")
                actual_line %(+         "Goodbye world")
                plain_line '        ]'
                plain_line '      ],'
                plain_line '      {'
                actual_line %(+       id: "hero",)
                plain_line %(        class: "header",)
                plain_line '        data: {'
                expected_line %(-         "sticky" => true,)
                actual_line %(+         "sticky" => false,)
                actual_line %(+         :role => "deprecated",)
                plain_line '          :person => #<SuperDiff::Test::Person {'
                expected_line %(-           name: "Marty",)
                actual_line %(+           name: "Doc",)
                plain_line '            age: 60'
                plain_line '          }>'
                plain_line '        }'
                plain_line '      }'
                plain_line '    ],'
                actual_line '+   :br'
                plain_line '  ]'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST
          value = [
            [
              :h1,
              [:span, [:text, "Hello world"]],
              {
                class: "header",
                data: {
                  "sticky" => true,
                  person: SuperDiff::Test::Person.new(name: "Marty", age: 60)
                }
              }
            ]
          ]
          expect(value).not_to eq(value)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(value).not_to eq(value)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual %([[:h1, [:span, [:text, "Hello world"]], { class: "header", data: { "sticky" => true, :person => #<SuperDiff::Test::Person name: "Marty", age: 60> } }]])
                end

                line do
                  plain 'not to eq '
                  expected %([[:h1, [:span, [:text, "Hello world"]], { class: "header", data: { "sticky" => true, :person => #<SuperDiff::Test::Person name: "Marty", age: 60> } }]])
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two hashes with other data structures inside' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = {
            customer: {
              person: SuperDiff::Test::Person.new(name: "Marty McFly, Jr.", age: 17),
              shipping_address: {
                line_1: "456 Ponderosa Ct.",
                city: "Hill Valley",
                state: "CA",
                zip: "90382"
              }
            },
            items: [
              {
                name: "Fender Stratocaster",
                cost: 100_000,
                options: ["red", "blue", "green"]
              },
              { name: "Mattel Hoverboard" }
            ]
          }
          expected = {
            customer: {
              person: SuperDiff::Test::Person.new(name: "Marty McFly", age: 17),
              shipping_address: {
                line_1: "123 Main St.",
                city: "Hill Valley",
                state: "CA",
                zip: "90382"
              }
            },
            items: [
              {
                name: "Fender Stratocaster",
                cost: 100_000,
                options: ["red", "blue", "green"]
              },
              { name: "Chevy 4x4" }
            ]
          }
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %({ customer: { person: #<SuperDiff::Test::Person name: "Marty McFly, Jr.", age: 17>, shipping_address: { line_1: "456 Ponderosa Ct.", city: "Hill Valley", state: "CA", zip: "90382" } }, items: [{ name: "Fender Stratocaster", cost: 100000, options: ["red", "blue", "green"] }, { name: "Mattel Hoverboard" }] })
                end

                line do
                  plain '   to eq '
                  expected %({ customer: { person: #<SuperDiff::Test::Person name: "Marty McFly", age: 17>, shipping_address: { line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" } }, items: [{ name: "Fender Stratocaster", cost: 100000, options: ["red", "blue", "green"] }, { name: "Chevy 4x4" }] })
                end
              end,
            diff:
              proc do
                plain_line '  {'
                plain_line '    customer: {'
                plain_line '      person: #<SuperDiff::Test::Person {'
                expected_line %(-       name: "Marty McFly",)
                actual_line %(+       name: "Marty McFly, Jr.",)
                plain_line '        age: 17'
                plain_line '      }>,'
                plain_line '      shipping_address: {'
                expected_line %(-       line_1: "123 Main St.",)
                actual_line %(+       line_1: "456 Ponderosa Ct.",)
                plain_line %(        city: "Hill Valley",)
                plain_line %(        state: "CA",)
                plain_line %(        zip: "90382")
                plain_line '      }'
                plain_line '    },'
                plain_line '    items: ['
                plain_line '      {'
                plain_line %(        name: "Fender Stratocaster",)
                plain_line '        cost: 100000,'
                plain_line '        options: ['
                plain_line %(          "red",)
                plain_line %(          "blue",)
                plain_line %(          "green")
                plain_line '        ]'
                plain_line '      },'
                plain_line '      {'
                expected_line %(-       name: "Chevy 4x4")
                actual_line %(+       name: "Mattel Hoverboard")
                plain_line '      }'
                plain_line '    ]'
                plain_line '  }'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          value = {
            customer: {
              person: SuperDiff::Test::Person.new(name: "Marty McFly", age: 17),
              shipping_address: {
                line_1: "123 Main St.",
                city: "Hill Valley",
                state: "CA",
                zip: "90382"
              }
            },
            items: [
              {
                name: "Fender Stratocaster",
                cost: 100_000,
                options: ["red", "blue", "green"]
              },
              { name: "Chevy 4x4" }
            ]
          }
          expect(value).not_to eq(value)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(value).not_to eq(value)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual %({ customer: { person: #<SuperDiff::Test::Person name: "Marty McFly", age: 17>, shipping_address: { line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" } }, items: [{ name: "Fender Stratocaster", cost: 100000, options: ["red", "blue", "green"] }, { name: "Chevy 4x4" }] })
                end

                line do
                  plain 'not to eq '
                  expected %({ customer: { person: #<SuperDiff::Test::Person name: "Marty McFly", age: 17>, shipping_address: { line_1: "123 Main St.", city: "Hill Valley", state: "CA", zip: "90382" } }, items: [{ name: "Fender Stratocaster", cost: 100000, options: ["red", "blue", "green"] }, { name: "Chevy 4x4" }] })
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two different kinds of custom objects' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = SuperDiff::Test::Customer.new(
            name: "Doc",
            shipping_address: :some_shipping_address,
            phone: "1234567890",
          )
          expected = SuperDiff::Test::Person.new(
            name: "Marty",
            age: 31,
          )
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %(#<SuperDiff::Test::Customer name: "Doc", shipping_address: :some_shipping_address, phone: "1234567890">)
                end

                line do
                  plain '   to eq '
                  expected %(#<SuperDiff::Test::Person name: "Marty", age: 31>)
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          value = SuperDiff::Test::Person.new(
            name: "Marty",
            age: 31,
          )
          expect(value).not_to eq(value)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(value).not_to eq(value)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual %(#<SuperDiff::Test::Person name: "Marty", age: 31>)
                end

                line do
                  plain 'not to eq '
                  expected %(#<SuperDiff::Test::Person name: "Marty", age: 31>)
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two different kinds of non-custom objects' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = SuperDiff::Test::Player.new(
            handle: "mcmire",
            character: "Jon",
            inventory: ["sword"],
            shields: 11.4,
            health: 4,
            ultimate: true,
          )
          expected = SuperDiff::Test::Item.new(
            name: "camera",
            quantity: 3,
          )
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual %(#<SuperDiff::Test::Player @character="Jon", @handle="mcmire", @health=4, @inventory=["sword"], @shields=11.4, @ultimate=true>)
                end

                line do
                  plain '   to eq '
                  expected %(#<SuperDiff::Test::Item @name="camera", @quantity=3>)
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end

    it 'produces the correct failure message when used in the negative' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          value = SuperDiff::Test::Item.new(
            name: "camera",
            quantity: 3,
          )
          expect(value).not_to eq(value)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(value).not_to eq(value)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain ' Expected '
                  actual %(#<SuperDiff::Test::Item @name="camera", @quantity=3>)
                end

                line do
                  plain 'not to eq '
                  expected %(#<SuperDiff::Test::Item @name="camera", @quantity=3>)
                end
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing two data structures where one contains an empty array' do
    it 'formats the array correctly in the diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = { foo: [] }
          expected = { foo: nil }
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '{ foo: [] }'
                  plain ' to eq '
                  expected '{ foo: nil }'
                  plain '.'
                end
              end,
            diff:
              proc do
                plain_line '  {'
                expected_line '-   foo: nil'
                actual_line '+   foo: []'
                plain_line '  }'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two data structures where one contains an empty hash' do
    it 'formats the hash correctly in the diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = { foo: {} }
          expected = { foo: nil }
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '{ foo: {} }'
                  plain ' to eq '
                  expected '{ foo: nil }'
                  plain '.'
                end
              end,
            diff:
              proc do
                plain_line '  {'
                expected_line '-   foo: nil'
                actual_line '+   foo: {}'
                plain_line '  }'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing two data structures where one contains an empty object' do
    it 'formats the object correctly in the diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = { foo: SuperDiff::Test::EmptyClass.new }
          expected = { foo: nil }
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '{ foo: #<SuperDiff::Test::EmptyClass> }'
                  plain ' to eq '
                  expected '{ foo: nil }'
                  plain '.'
                end
              end,
            diff:
              proc do
                plain_line '  {'
                expected_line '-   foo: nil'
                actual_line '+   foo: #<SuperDiff::Test::EmptyClass>'
                plain_line '  }'
              end
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing ranges' do
    it 'produces the correct failure message when used in the positive' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = 'expect(1..5).to eq(5..6)'
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: snippet,
            newline_before_expectation: true,
            expectation:
              proc do
                line do
                  plain 'Expected '
                  actual '1..5'
                  plain ' to eq '
                  expected '5..6'
                  plain '.'
                end
              end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        )
      end
    end
  end

  context 'when comparing procs (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = Proc.new { 'hello' }
          expected = Proc.new { 'oh, hi!' }
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual '#<Proc>'
                plain ' to eq '
                expected '#<Proc>'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing booleans (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = true
          expected = false
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual 'true'
                plain ' to eq '
                expected 'false'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing nils (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = nil
          expected = 'something else'
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual 'nil'
                plain ' to eq '
                expected '"something else"'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing symbols (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = :test
          expected = :different_symbol
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual ':test'
                plain ' to eq '
                expected ':different_symbol'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing numerics (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = 4
          expected = 2.5
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual '4'
                plain ' to eq '
                expected '2.5'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing regexps (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = /test/
          expected = /another regexp/
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual '/test/'
                plain ' to eq '
                expected '/another regexp/'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing classes (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          class Test; end
          class AnotherClass; end
          expect(Test.new).to eq(AnotherClass.new)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(Test.new).to eq(AnotherClass.new)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual '#<Test>'
                plain ' to eq '
                expected '#<AnotherClass>'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing Modules (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          module Test; end
          module AnotherClass; end
          expect(Test).to eq(AnotherClass)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(Test).to eq(AnotherClass)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual 'Test'
                plain ' to eq '
                expected 'AnotherClass'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  context 'when comparing strings (a kind of primitive)' do
    it 'generates the correct expectation and does not generate a diff' do
      as_both_colored_and_uncolored do |color_enabled|
        snippet = <<~TEST.strip
          actual = 'test'
          expected = 'another string'
          expect(actual).to eq(expected)
        TEST
        program = make_plain_test_program(snippet, color_enabled: color_enabled)

        expected_output =
          build_expected_output(
            color_enabled: color_enabled,
            snippet: 'expect(actual).to eq(expected)',
            newline_before_expectation: false,
            expectation: proc do
              line do
                plain 'Expected '
                actual '"test"'
                plain ' to eq '
                expected '"another string"'
                plain '.'
              end
            end,
            diff: nil
          )

        expect(program).to produce_output_when_run(expected_output).in_color(
          color_enabled
        ).removing_object_ids
      end
    end
  end

  it_behaves_like 'a matcher that supports elided diffs' do
    let(:matcher) { :eq }
  end

  it_behaves_like 'a matcher that supports a toggleable key' do
    let(:matcher) { :eq }
  end
end
