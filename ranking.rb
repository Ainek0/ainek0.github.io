#!/usr/bin/env ruby
#
require 'net/http'
require 'sinatra'

SECRET = 'pJn2BuyQLFXKjWSuspLEm4C1vBv4cTNs'
URL = {
  host: 'https://api.coin-hive.com',
  balance: '/user/balance',
  stats_site: '/stats/site'
}

class Client
  attr_accessor :host

  def initialize
    @host = URL[:host]
  end

  def request(uri, apisign = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.start
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end

  def public_request(endpoint, params = {})
    request(uri(endpoint, params))
  end

  def private_request(endpoint, params = {})
    params = { 'secret' => SECRET }.merge(params)
    uri = uri(endpoint, params)
    request(uri)
  end

  def uri(endpoint, params = {})
    query = URI.encode_www_form(params.to_a)
    URI.parse("#{host}#{endpoint}?#{query}")
  end


  def balance(name)
    private_request(URL[:balance], name: name)
  end

  def stats_site
    private_request(URL[:stats_site])
  end
end

# puts 'Ranking'
client = Client.new
# balance = client.balance('4c0f713a-a7ed-412b-e451-7cb1c9946e44')
stats_site = client.stats_site
# puts 'BALANCE', balance.body
puts stats_site.body
