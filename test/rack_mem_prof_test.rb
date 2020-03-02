require 'fileutils'
require 'rack/mem_prof'
require 'test/unit'
require 'rack/test'
require 'mocha'
require 'mocha/setup'
require 'dummy_app'

class RackMemProfTest < Test::Unit::TestCase
  include Rack::Test::Methods

  attr_accessor :app

  def teardown
    @app = nil
  end

  def test_report_created
    self.app = Rack::MemProf::Middleware.new(DummyApp.freeze.app)

    MemoryProfiler.expects(:start).once
    MemoryProfiler.expects(:stop).once
    app.expects(:write_report).once

    get '/'

    assert last_response.ok?
  end
end
