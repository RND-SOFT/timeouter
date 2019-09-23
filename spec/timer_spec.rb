RSpec.describe Timeouter::Timer do
  let(:timeout){ 0 }
  let(:eclass){ nil }
  let(:emessage){ nil }
  subject(:timer){ described_class.new(timeout, eclass: eclass, message: emessage) }

  describe 'Infinite Timer' do
    it { is_expected.not_to be_exhausted }
    it { is_expected.to be_running }

    describe '#elapsed' do
      subject{ timer.elapsed }
      it { is_expected.to be > 0 }
    end

    describe '#left' do
      subject{ timer.left }
      it { is_expected.to be_nil }
    end

    describe '#exhausted?' do
      subject{ timer.exhausted? }
      it { is_expected.to be_nil }
    end

    describe '#running!' do
      subject{ ->{ timer.running! } }
      it { is_expected.not_to raise_exception }
    end

    describe '#loop result' do
      subject{ timer.loop { break 222 } }
      it { is_expected.to eq(222) }
    end

    describe '#loop! result' do
      subject{ timer.loop! { break 333 } }
      it { is_expected.to eq(333) }
    end
  end

  describe 'Normal Timer ' do
    let(:timeout){ 1 }

    describe 'within timeout' do
      before { allow(timer).to receive(:elapsed).and_return(0.5) }

      it { is_expected.not_to be_exhausted }
      it { is_expected.to be_running }

      describe '#elapsed' do
        subject{ timer.elapsed }
        it { is_expected.to be > 0 }
      end

      describe '#left' do
        subject{ timer.left }
        it { is_expected.not_to be_nil }
        it { is_expected.to be < timeout }
      end

      describe '#exhausted?' do
        subject{ timer.exhausted? }
        it { is_expected.not_to be_nil }
      end

      describe '#running!' do
        subject{ ->{ timer.running! } }
        it { is_expected.not_to raise_exception }
      end

      describe '#loop result' do
        subject{ timer.loop { break 222 } }
        it { is_expected.to eq(222) }
      end

      describe '#loop! result' do
        subject{ timer.loop! { break 333 } }
        it { is_expected.to eq(333) }
      end
    end

    describe 'after timeout' do
      before { allow(timer).to receive(:elapsed).and_return(1.5) }

      it { is_expected.to be_exhausted }
      it { is_expected.not_to be_running }

      describe '#elapsed' do
        subject{ timer.elapsed }
        it { is_expected.to be > 0 }
      end

      describe '#left' do
        subject{ timer.left }
        it { is_expected.not_to be_nil }
        it { is_expected.to eq(0) }
      end

      describe '#exhausted?' do
        subject{ timer.exhausted? }
        it { is_expected.not_to be_nil }
      end

      describe '#running!' do
        subject{ ->{ timer.running! } }
        it { is_expected.to raise_exception(Timeouter::TimeoutError, 'execution expired') }

        describe 'with predifined exception' do
          let(:eclass){ RuntimeError }
          let(:emessage){ 'predifined' }
          it { is_expected.to raise_exception(eclass, emessage) }
        end

        describe 'with custom exception' do
          subject{ ->{ timer.running!(RuntimeError, message: 'custom') } }
          it { is_expected.to raise_exception(RuntimeError, 'custom') }
        end
      end

      describe '#loop result' do
        subject{ timer.loop { break 222 } }
        it { is_expected.to be_nil }
      end

      describe '#loop! result' do
        subject{ ->{ timer.loop! { break 333 } } }
        it { is_expected.to raise_exception(Timeouter::TimeoutError, 'execution expired') }
      end
    end
  end
end

