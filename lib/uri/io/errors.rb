
module URI
  module IO
    class Error < ::StandardError;                end

    class UnsupportedOperation < URI::IO::Error;  end
    class HandlerNotFound < URI::IO::Error;        end
  end
end
