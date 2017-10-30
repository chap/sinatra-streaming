require "sinatra"
require "sinatra/streaming"

class StupidMiddleware
  def initialize(app) @app = app end

  def call(env)
    status, headers, body = @app.call(env)
    body.map! { |e| e.upcase }
    [status, headers, body]
  end
end

use StupidMiddleware

get '/' do
  number_to_stream = (ENV['NUMBER_TO_STREAM'] || 10)
  stream do |out|
    out.puts "still"
    while number_to_stream > 0
      sleep 1
      out.puts number_to_stream
      number_to_stream = number_to_stream - 1
    end
    sleep 1
    out.puts "streaming"
  end
end
