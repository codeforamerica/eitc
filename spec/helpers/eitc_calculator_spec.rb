require 'rails_helper'

describe EitcCalculator do
  let(:klass_instance) do
    class MyDummyClass
      include EitcCalculator
    end

    MyDummyClass.new
  end

  describe '#calculate_eitc_refund' do
    context 'single filter' do
      let(:status) { 'single' }

      context 'with no kids' do
        let(:children) { 0 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 14999 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 3
          end
        end

        context 'too much income' do
          let(:income) { 15000 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with one kid' do
        let(:children) { 1 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 39599 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 7
          end
        end

        context 'too much income' do
          let(:income) { 39600 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with two kids' do
        let(:children) { 2 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 44000 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 207
          end
        end

        context 'too much income' do
          let(:income) { 50000 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with three kids' do
        let(:children) { 3 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 48000 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 66
          end
        end

        context 'too much income' do
          let(:income) { 49000 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end
    end

    context 'filing jointly' do
      let(:status) { 'joint' }

      context 'with no kids' do
        let(:children) { 0 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 20000 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 44
          end
        end

        context 'too much income' do
          let(:income) { 21000 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with one kid' do
        let(:children) { 1 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 45000 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 29
          end
        end

        context 'too much income' do
          let(:income) { 45200 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with two kids' do
        let(:children) { 2 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 50599 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 5
          end
        end

        context 'too much income' do
          let(:income) { 50600 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end

      context 'with three kids' do
        let(:children) { 3 }

        context 'no income' do
          let(:income) { 0 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end

        context 'eligible income' do
          let(:income) { 53949 }

          it 'returns the award amount' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 1
          end
        end

        context 'too much income' do
          let(:income) { 53950 }

          it 'returns zero' do
            result = klass_instance.calculate_eitc_refund(status: status, children: children, income: income)
            expect(result).to eq 0
          end
        end
      end
    end
  end
end