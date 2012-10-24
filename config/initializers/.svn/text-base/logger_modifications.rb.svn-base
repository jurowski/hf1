$mongrel_port = '' # set this in case we are not using mongrel

# just need to set this once...
$process_pid = Process.pid

# Rails > 2.0 uses BufferedLogger
module ActiveSupport
  class BufferedLogger
    module Severity

      # ideas for this from : http://rubyclub.com.ua/messages/show/1122
      def level_to_s(level)
        case level
        when 0 : 'DEBUG'
        when 1 : 'INFO'
        when 2 : 'WARN'
        when 3 : 'ERROR'
        when 4 : 'ERROR'
        when 5 : 'UNKNOWN'
        end
      end
    end

    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      unless RAILS_ENV == ('development' || 'test')
        message = "#{Time.now.utc.strftime("%Y-%m-%d %H:%M:%S %Z")} | #{level_to_s(severity)} | #{$process_pid} | #{message}\n"
      end
      # If a newline is necessary then create a new message ending with a newline.
      # Ensures that the original message is not mutated.
      message = "#{message}\n" unless message[-1] == ?\n
      buffer << message
      auto_flush
      message
    end

  end
end
