# encoding: utf-8

class BadBill
  # Forward all methods to an underlying object called data.
  #
  # This acts like a proxy object.
  module ForwardMethods
    # Respond to method_missing to send down the line.
    #
    # As Hashie::Mash#method_missing does not respond with true to an
    # assignment request, we only check for the method name without the equal sign.
    def method_missing(method_name, *arguments, &block)
      if data.respond_to?(method_name.to_s.sub(/=$/, ''))
        if method_name.to_s.end_with?('=')
          @__mutated__ ||= []
          @__mutated__ << method_name.to_s.sub(/=$/, '')
          @__mutated__.uniq!
        end

        data.send(method_name, *arguments, &block)
      else
        super
      end
    end

    # Proxy respond_to? to the underlying object if needed.
    #
    # If playing with method_missing define respond_to? too.
    # See http://robots.thoughtbot.com/post/28335346416/always-define-respond-to-missing-when-overriding
    #
    # @return [Boolean] True if the class itself or the proxied object responds to the given method.
    def respond_to?(method_name, include_private = false)
      super || data.respond_to?(method_name, include_private)
    end
  end
end
