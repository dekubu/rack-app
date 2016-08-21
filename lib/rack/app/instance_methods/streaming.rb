module Rack::App::InstanceMethods::Streaming
  #
  # Copyright (c) 2007, 2008, 2009 Blake Mizerany
  # Copyright (c) 2010, 2011, 2012, 2013, 2014, 2015, 2016 Konstantin Haase
  #
  # Allows to start sending data to the client even though later parts of
  # the response body have not yet been generated.
  #
  # The close parameter specifies whether Stream#close should be called
  # after the block has been executed. This is only relevant for evented
  # servers like Thin or Rainbows.
  def stream(keep_open = false)
    scheduler = Rack::App::Streamer::Scheduler.by_env(request.env)
    response.body = Rack::App::Streamer.new(scheduler, keep_open) { |out| yield(out) }
    finish_response
  end
end
