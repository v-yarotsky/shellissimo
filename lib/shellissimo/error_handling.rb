module Shellissimo

  #
  # Wraps code in catch-all block
  #
  def self.with_error_handling
    begin
      yield
    rescue SystemExit
      exit 0
    rescue Exception => e
      $stderr.puts "An error occured: #{e.message}"
      if ENV['DEBUG']
        $stderr.puts e.class.name
        $stderr.puts e.backtrace
      end
    end
  end

end
