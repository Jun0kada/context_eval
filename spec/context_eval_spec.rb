require 'spec_helper'

RSpec.describe ContextEval, type: :model do
  describe '#context_eval' do
    let(:model) do
      Struct.new(:name)
    end

    subject { model.new('john').context_eval(arg) }

    context 'with symbol' do
      let(:arg) { :name }

      it { is_expected.to eq('john') }
    end

    context 'with proc' do
      let(:arg) { Proc.new { "Name: #{name}" } }

      it { is_expected.to eq('Name: john') }

      context 'and args' do
        let(:arg) { Proc.new { |s| "Name: #{name}. #{s}" } }

        subject { model.new('john').context_eval(arg, 'with context arg') }

        it { is_expected.to eq('Name: john. with context arg') }

        context '.arity < 0' do
          let(:arg) { Proc.new { |*s| "Name: #{name}. #{s}" } }

          subject { model.new('john').context_eval(arg, 1, 2, 3) }

          it { is_expected.to eq('Name: john. [1, 2, 3]') }
        end
      end
    end

    context 'with lambda' do
      let(:arg) { -> { "Name: #{name}" } }

      it { is_expected.to eq('Name: john') }

      context 'and args' do
        let(:arg) { -> (s) { "Name: #{name}. #{s}" } }

        subject { model.new('john').context_eval(arg, 'with context arg') }

        it { is_expected.to eq('Name: john. with context arg') }

        context '.arity < 0' do
          let(:arg) { -> (*s) { "Name: #{name}. #{s}" } }

          subject { model.new('john').context_eval(arg, 1, 2, 3) }

          it { is_expected.to eq('Name: john. [1, 2, 3]') }
        end
      end
    end

    context 'with string' do
      let(:arg) { 'arg' }

      it { is_expected.to eq('arg') }
    end


    context 'with nil' do
      let(:arg) { nil }

      it { is_expected.to eq(nil) }
    end
  end
end
