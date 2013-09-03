# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    module Style
      describe ParenthesesAroundCondition do
        subject(:cop) { ParenthesesAroundCondition.new }
        before do
          ParenthesesAroundCondition.config = { 'AllowSafeAssignment' => true }
        end

        it 'registers an offence for parentheses around condition' do
          inspect_source(cop, ['if (x > 10)',
                               'elsif (x < 3)',
                               'end',
                               'unless (x > 10)',
                               'end',
                               'while (x > 10)',
                               'end',
                               'until (x > 10)',
                               'end',
                               'x += 1 if (x < 10)',
                               'x += 1 unless (x < 10)',
                               'x += 1 while (x < 10)',
                               'x += 1 until (x < 10)',
                              ])
          expect(cop.offences.size).to eq(9)
        end

        it 'accepts condition without parentheses' do
          inspect_source(cop, ['if x > 10',
                               'end',
                               'unless x > 10',
                               'end',
                               'while x > 10',
                               'end',
                               'until x > 10',
                               'end',
                               'x += 1 if x < 10',
                               'x += 1 unless x < 10',
                               'x += 1 while x < 10',
                               'x += 1 until x < 10',
                              ])
          expect(cop.offences).to be_empty
        end

        it 'is not confused by leading brace in subexpression' do
          inspect_source(cop, ['(a > b) && other ? one : two'])
          expect(cop.offences).to be_empty
        end

        it 'is not confused by unbalanced parentheses' do
          inspect_source(cop, ['if (a + b).c()',
                               'end'])
          expect(cop.offences).to be_empty
        end

        context 'safe assignment is allowed' do
          it 'accepts = in condition surrounded with braces' do
            inspect_source(cop,
                           ['if (test = 10)',
                            'end'
                           ])
            expect(cop.offences).to be_empty
          end

        end

        context 'safe assignment is not allowed' do
          before do
            ParenthesesAroundCondition.config['AllowSafeAssignment'] = false
          end

          it 'does not accepts = in condition surrounded with braces' do
            inspect_source(cop,
                           ['if (test = 10)',
                            'end'
                           ])
            expect(cop.offences.size).to eq(1)
          end
        end
      end
    end
  end
end