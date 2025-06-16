require 'openai'

OpenAI::Client.new(
  access_token: ENV['OPENAI_API_KEY'],
  request_timeout: 120
)
