module Error
  class CustomError < StandardError
    attr_reader :status_code, :turing_code, :field
    def initialize(status_code=nil, turing_code=nil, field=nil)
      @status_code = status_code || 422
      @turing_code = turing_code || :UNPROCESSABLE
      @field = field || "field"
    end

    def self.error(status_code=nil, turing_code=nil, field=nil)
      self.new(status_code, turing_code, field)
    end

  end
end