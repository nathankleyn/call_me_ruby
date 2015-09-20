require 'spec_helper'
require 'call_me_ruby'

RSpec.describe(CallMeRuby) do
  let(:test_class) do
    Class.new do
      def success
        true
      end

      def failure
        false
      end
    end
  end
  let(:test_class_with_callbacks) { test_class.tap { |k| k.include(described_class) } }
  subject { test_class_with_callbacks.new }

  describe('.subscribe') do
    it('registers callbacks at the class level') do
      callback = proc {}
      subject.class.subscribe(:test, :success, :another_success, &callback)

      expect(subject.class.class_callbacks).to eql(test: [:success, :another_success, callback])
      expect(subject.callbacks).to eql({})
    end
  end

  describe('#subscribe') do
    it('registers callbacks at the instance level') do
      callback = proc {}
      subject.subscribe(:test, :success, :another_success, &callback)

      expect(subject.class.class_callbacks).to eql({})
      expect(subject.callbacks).to eql(test: [:success, :another_success, callback])
    end
  end

  describe('#publish') do
    it('triggers callbacks at the class level') do
      subject.class.subscribe(:test, :success)

      expect(subject).to receive(:success)

      subject.publish(:test)
    end

    it('triggers callbacks at the instance level') do
      subject.subscribe(:test, :success)

      expect(subject).to receive(:success)

      subject.publish(:test)
    end

    it('triggers callbacks given as blocks') do
      block_called = false
      callback = proc { block_called = true }
      subject.subscribe(:test, &callback)

      subject.publish(:test)

      expect(block_called).to be(true)
    end

    it('returns true if all of the callbacks return true') do
      subject.class.subscribe(:test, :success)
      subject.subscribe(:test, :success)

      expect(subject.publish(:test)).to be(true)
    end

    it('returns false if any of the callbacks return false') do
      subject.class.subscribe(:test, :success)
      subject.subscribe(:test, :failure)

      expect(subject.publish(:test)).to be(false)
    end

    it('returns early when one of the callbacks returns false explicitly') do
      subject.class.subscribe(:test, :failure)
      subject.subscribe(:test, :success)

      expect(subject).to receive(:failure).and_return(false)
      expect(subject).to_not receive(:success)

      subject.publish(:test)
    end
  end

  describe('#subscribed?') do
    it('returns true if an event is subscribed at the class level with the given name') do
      subject.class.subscribe(:class_event, :success)

      expect(subject.subscribed?(:class_event)).to be(true)
    end

    it('returns true if an event is subscribed at the instance level with the given name') do
      subject.subscribe(:instance_event, :success)

      expect(subject.subscribed?(:instance_event)).to be(true)
    end

    it('returns false if no events are subscribed with the given name') do
      expect(subject.subscribed?(:failure)).to be(false)
    end
  end
end
