# frozen_string_literal: true

require 'spec_helper'
require 'call_me_ruby'

RSpec.describe(CallMeRuby) do
  subject(:test_class) do
    Class.new do
      include CallMeRuby

      attr_reader :success_called, :failure_called

      def initialize
        @success_called = false
        @failure_called = false
      end

      def success
        @success_called = true
      end

      def failure
        @failure_called = true
        false
      end
    end.new
  end

  describe('.subscribe') do
    it('registers callbacks at the class level') do
      callback = proc {}
      test_class.class.subscribe(:test, :success, :another_success, &callback)

      expect(test_class.class.class_callbacks).to eql(test: [:success, :another_success, callback])
      expect(test_class.callbacks).to eql({})
    end
  end

  describe('#subscribe') do
    it('registers callbacks at the instance level') do
      callback = proc {}
      test_class.subscribe(:test, :success, :another_success, &callback)

      expect(test_class.class.class_callbacks).to eql({})
      expect(test_class.callbacks).to eql(test: [:success, :another_success, callback])
    end
  end

  describe('#publish') do
    it('triggers callbacks at the class level') do
      test_class.class.subscribe(:test, :success)
      test_class.publish(:test)

      expect(test_class.success_called).to be(true)
    end

    it('triggers callbacks at the instance level') do
      test_class.subscribe(:test, :success)
      test_class.publish(:test)

      expect(test_class.success_called).to be(true)
    end

    it('triggers callbacks given as blocks') do
      block_called = false
      callback = proc { block_called = true }
      test_class.subscribe(:test, &callback)

      test_class.publish(:test)

      expect(block_called).to be(true)
    end

    it('returns true if all of the callbacks return true') do
      test_class.class.subscribe(:test, :success)
      test_class.subscribe(:test, :success)

      expect(test_class.publish(:test)).to be(true)
    end

    it('returns false if any of the callbacks return false') do
      test_class.class.subscribe(:test, :success)
      test_class.subscribe(:test, :failure)

      expect(test_class.publish(:test)).to be(false)
    end

    it('returns early when one of the callbacks returns false explicitly') do
      test_class.class.subscribe(:test, :failure)
      test_class.subscribe(:test, :success)

      expect(test_class.success_called).to be(false)

      test_class.publish(:test)
    end
  end

  describe('#subscribed?') do
    it('returns true if an event is subscribed at the class level with the given name') do
      test_class.class.subscribe(:class_event, :success)

      expect(test_class.subscribed?(:class_event)).to be(true)
    end

    it('returns true if an event is subscribed at the instance level with the given name') do
      test_class.subscribe(:instance_event, :success)

      expect(test_class.subscribed?(:instance_event)).to be(true)
    end

    it('returns false if no events are subscribed with the given name') do
      expect(test_class.subscribed?(:failure)).to be(false)
    end
  end
end
