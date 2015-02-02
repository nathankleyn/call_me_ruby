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
      subject.class.subscribe(:test, :success)

      expect(subject.class.class_callbacks).to eql(test: [:success])
      expect(subject.callbacks).to eql({})
    end
  end

  describe('#subscribe') do
    it('registers callbacks at the instance level') do
      subject.subscribe(:test, :success)

      expect(subject.class.class_callbacks).to eql({})
      expect(subject.callbacks).to eql(test: [:success])
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

    it('returns early when one of the callbacks fails') do
      subject.class.subscribe(:test, :failure)
      subject.subscribe(:test, :success)

      expect(subject).to receive(:failure)
      expect(subject).to_not receive(:success)

      subject.publish(:test)
    end
  end
end
