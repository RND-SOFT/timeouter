RSpec.describe Timeouter do
  subject{ described_class }

  let(:timer){ double(Timeouter::Timer) }
  let(:timeout){rand(100000)}
  let(:message){rand(100000000).to_s}

  describe '#run' do
    it 'should yield Timer' do
      expect(Timeouter::Timer).to receive(:new)
        .with(timeout, eclass: RuntimeError, message: message)
        .and_call_original

      subject.run(timeout, eclass: RuntimeError, message: message) do |t|
        expect(t).to be_a(Timeouter::Timer)
      end
    end
  end

  describe '#loop' do
    it 'should loop to timer' do
      expect(timer).to receive(:loop)
      expect(Timeouter::Timer).to receive(:new)
        .with(timeout, eclass: RuntimeError, message: message)
        .and_return(timer)

      subject.loop(timeout, eclass: RuntimeError, message: message)
    end
  end

  describe '#loop!' do
    it 'should loop! to timer' do
      expect(timer).to receive(:loop!)
      expect(Timeouter::Timer).to receive(:new)
        .with(timeout, eclass: RuntimeError, message: message)
        .and_return(timer)

      subject.loop!(timeout, eclass: RuntimeError, message: message)
    end
  end
end

