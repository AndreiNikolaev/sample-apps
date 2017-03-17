require 'open3'
require 'logger'
require 'json'

$logger = Logger.new(STDOUT)
$logger.level = Logger::WARN

class SimpleLog
  def self.log
    if @logger.nil?
      @logger = Logger.new STDOUT
      @logger.level = Logger::DEBUG
    end
    @logger
  end
end

# Run the apc command with the given parameters.
def apc(command)
  cmd_line = "apc #{command} --batch"
  stdout, stderr, status = execute(cmd_line)

  SimpleLog.log.info { "STDOUT: #{stdout}" } unless stdout.empty?
  SimpleLog.log.info { "STDERR: #{stderr}" } unless stderr.empty?

  [stdout, stderr, status]
end

def execute(command)
  Open3.capture3(command)
end

def get(url)
  uri = URI(url)
  Net::HTTP.get_response(uri)
end

# This janky way of getting the route, but at the moment we don't want to
# go an implement the API.
def route(app)
  cmd_line = "apc job show #{app} | grep Route | awk '{print $4}'"
  stdout, stderr, status = execute(cmd_line)
  stdout.strip
end

# If provided then true, else false
def provided?(name)
  cmd_line = "apc package list -ns / --json"
  stdout, stderr, status = execute(cmd_line)
  JSON.parse(stdout).each do |package|
    if package['provides']
      package['provides'].each do |providers|
        if providers['name'] == name
          return true
        end
      end
    end
  end
  false
end

def provided(name)
  if provided? name
    yield
  end
end