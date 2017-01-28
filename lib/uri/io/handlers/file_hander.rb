require 'fileutils'

module URI::IO::FileHandler
  class << self
    def read(uri)
      File.read uri
    end

    def write(uri, data)
      File.write(uri.filepath) do |f|
        f.write(data)
      end
    end

    def delete(uri)
      FileUtils.rm uri.filepath
    end
  end

  URI::IO.register_handler(URI::IO::FileHandler, operations: %i(read write delete))
end
