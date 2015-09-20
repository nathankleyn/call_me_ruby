# A mixin to implement publish/subscribe style callbacks in the class that
# includes this.
module CallMeRuby
  # The self.included idiom. This is described in great detail in a
  # fantastic blog post here:
  #
  # http://www.railstips.org/blog/archives/2009/05/15/include-vs-extend-in-ruby/
  #
  # Basically, this idiom allows us to add both instance *and* class methods
  # to the class that is mixing this module into itself without forcing them
  # to call extend and include for this mixin. You'll see this idiom everywhere
  # in the Ruby/Rails world, so we use it too.
  def self.included(cls)
    cls.extend(ClassMethods)
  end

  # Common methods inherited by all classes
  module ClassMethods
    def class_callbacks
      @class_callbacks ||= Hash.new { |h, k| h[k] = [] }
    end

    def subscribe(name, *methods, &block)
      methods.each { |method| class_callbacks[name] << method }
      class_callbacks[name] << block if block_given?
    end
  end

  def callbacks
    @callbacks ||= Hash.new { |h, k| h[k] = [] }
  end

  def subscribe(name, *methods, &block)
    methods.each { |method| callbacks[name] << method }
    callbacks[name] << block if block_given?
  end

  def publish(name, *args)
    class_callback_methods = self.class.class_callbacks[name]
    callback_methods = callbacks[name]

    (class_callback_methods + callback_methods).each do |callback|
      result = (callback.respond_to?(:call) ? callback.call(*args) : send(callback, *args))
      # Exit early if the block explicitly returns `false`.
      return false if result == false
    end

    true
  end

  def subscribed?(name)
    self.class.class_callbacks.include?(name) || callbacks.include?(name)
  end
end
