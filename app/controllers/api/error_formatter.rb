module API
  module ErrorFormatter
    def self.call message, backtrace, options, env, original_exception
      {response_type: "loi roi do", response: message}.to_json
    end
  end
end
