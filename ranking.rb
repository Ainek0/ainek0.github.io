#!/usr/bin/env ruby
#
require 'net/http'
require 'sinatra'

SECRET = ENV['SECRET']
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
    private_request(URL[:balance], name: name).body
  end

  def stats_site
    private_request(URL[:stats_site]).body
  end
end

client = Client.new


get '/hello' do 
  puts client.balance(params[:user])
  'Hello Client'
end
