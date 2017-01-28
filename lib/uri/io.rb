require 'uri/io/version'
require 'uri/io/errors'

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
    # We constrain URI::IO to the same class-level operations of the top level ::IO
    # namespace as convenience. Not all methods will be implemented for every scheme.
    ALLOWED_IO_OPERATIONS = ::IO.methods - Object.methods + [ :delete ]

    # Returns root folder for this gem's sources
    def self.gem_root
      File.expand_path('../', File.basename(__FILE__))
    end

    # List of all registered handlers
    @handlers = {}

    class Proxy
      attr_accessor :uri, :handler

      def initialize(uri)
        self.uri = URI.parse(uri)
        self.handler = URI::IO.handlers[self.uri.scheme]
        raise HandlerNotFound, "Unable to handle scheme #{uri.scheme}, no registered handler found." unless self.handler
      end

      def method_missing(action, *args, **opts, &block)
        super unless handler || !handler.respond_to?(action)
        handler.send(action, *args, **opts, &block)
      end
    end

    class << self
      attr_accessor :handlers

      # Register a new handler class
      def register_handler(klass, **opts, &block)
        name = handler_name_from_class(klass)
        unknown_operations = (opts[:operations] || []) - ALLOWED_IO_OPERATIONS
        raise URI::IO::UnsupportedOperation, "Operation(s) #{unknown_operations} are not supported, only #{ALLOWED_IO_OPERATIONS} are." unless unknown_operations.empty?

        handlers[name] ||= {
          class:      klass,
          operations: opts.delete(:operations),
          options:    opts
        }

        yield handlers[name] if block_given?
        handlers[name]
      end

      def [](uri)
        URI::IO::Proxy.new(uri)
      end

      private

      def handler_name_from_class(klass)
        klass.name.gsub(/^URI::IO::(\w+)Handler$/, "\\1").downcase
      end
    end
  end
end

deps = []
deps << ::Dir.glob(::File.expand_path('../*.rb', __FILE__)).reject{ |f| f == __FILE__ }
deps << ::Dir.glob(::File.expand_path('../io/handlers/*.rb', __FILE__))
deps.flatten.compact.each { |f| require(f) }
