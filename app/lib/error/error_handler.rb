module Error
  module ErrorHandler
    def self.included(klass)
      klass.class_eval do
        rescue_from CustomError do |e|
          respond(e.status_code, e.turing_code, e.field)
        end
      end
    end

    def respond(status_code, turing_code, field)
      error = Helpers::Render.json(status_code, turing_code, field)
      render json: error, status: status_code
    end
  end
end