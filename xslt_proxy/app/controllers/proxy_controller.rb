require 'nokogiri'
require 'open-uri'

class ProxyController < ApplicationController
  before_action :parse_params, only: :output

  def input; end

  def output
    url = URL + "?number=#{@n}"
    api_response = open(url)

    case @transform
      when 'server'
        @result = server_side_transformation(api_response).to_html
      when 'client'
        render xml: client_side_transformation(api_response).to_xml
      else # default = 'without'
        render xml: api_response
    end
  end

  protected

  URL = 'http://localhost:3000/automorph/result.xml'.freeze
  TRANSFORM_URL = '/transform.xslt'.freeze
  TRANSFORM_PATH = "#{Rails.root}/public#{TRANSFORM_URL}".freeze

  def server_side_transformation(data, transform: TRANSFORM_PATH)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XSLT(File.read(transform))
    xslt.transform(doc)
  end

  def client_side_transformation(data, transform: TRANSFORM_URL)
    doc = Nokogiri::XML(data)
    xslt = Nokogiri::XML::ProcessingInstruction.new(doc,
                                                    'xml-stylesheet',
                                                    'type="text/xsl" href="' + transform + '"')
    doc.root.add_previous_sibling(xslt)
    doc
  end

  def parse_params
    @transform = params[:transform]
    @n = params[:number]
  end
end
