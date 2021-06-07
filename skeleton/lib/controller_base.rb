require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "double render not allowed" if already_built_response?
    res.status = 302
    res["Location"] = url
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = "text/html")
    raise "double render not allowed" if already_built_response?
    res.write(content)
    res['Content-Type'] = content_type
    @already_built_response = content
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise "double render not allowed" if already_built_response?
    # File.dirname(__FILE__) # views/cats_controller => we want to pass index
    content = File.read("views/cats_controller/index.html.erb")
    render_content(ERB.new(content).result(binding), content_type = "text/html")
    @already_built_response = true
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end



# path == "/cats"