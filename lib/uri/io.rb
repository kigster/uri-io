require 'uri/io/version'

module URI
  def self.register(klass, name = klass.name.gsub(/URI::/, ''))
    @@schemes[name] = klass
  end

  class Generic
    class << self
      def inherited(klass)
        URI.register(klass)
      end
    end
  end
end

module URI
  module IO
    class UnknownAction < StandardError;
    end
    class ParseError < StandardError;
    end

    @handlers = {}

    class << self
      attr_accessor :handlers

      def register_handler(klass, **opts, &block)
        name = klass.name.gsub(/^URI::IO::(\w+)Handler$/, "\\1").downcase
        handlers[name] ||= {
          class:      klass,
          operations: opts.delete(:operations),
          options:    opts
        }
        yield handlers[name] if block_given?
        handlers[name]
      end

      def method_missing(action, uri, *args, **opts, &block)
        scheme, = input.split('://')
        super unless handlers[scheme]
        action(name, *args, **opts, &block)
      end

      def action(action, uri, data = nil, **opts, &block)
        uri = URI.parse(uri)
        handlers[uri.scheme]&.send(action, uri, data, **opts, &block)
      end

    end
  end
end

deps = []
deps << ::Dir.glob(::File.expand_path('../*.rb', __FILE__)).reject{ |f| f == __FILE__ }
deps << ::Dir.glob(::File.expand_path('../io/handlers/*.rb', __FILE__))
deps.flatten.compact.each { |f| require(f) }
