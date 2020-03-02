require 'fileutils'
require 'memory_profiler'
require 'rack'
require 'pry'

module Rack
  module MemProf
    class Middleware
      REPEXT = '.txt'.freeze
      REPDIR = 'rack_mem_prof'.freeze

      def initialize(app, options = {})
        @app = app
        @path = options[:path] || "/tmp"
        @scale_bytes = options[:scale_bytes] || true
      end

      def call(env)
        MemoryProfiler.start
        status, headers, body = @app.call(env)
        write_report(MemoryProfiler.stop, env)

        [status, headers, body]
      rescue => e
        MemoryProfiler.stop
        raise e
      end

      private

      # report to "/tmp/rack_mem_prof/<request path>/<query params sha1>.txt"
      def write_report(report, env)
        request_report_path = ensure_path(env)
        report.pretty_print(
          scale_bytes: @scale_bytes,
          to_file: report_file(request_report_path, env)
        )
      end

      def report_file(request_report_path, env)
        filename = generate_filename(env['QUERY_STRING'])
        ::File.join(request_report_path, filename)
      end

      def ensure_path(env)
        request_dirname = webpath_to_dirname(env['PATH_INFO'])
        request_report_path = ::File.join(reports_path, request_dirname)
        FileUtils.mkdir_p request_report_path
      end

      def webpath_to_dirname(path_info)
        path_info.gsub(/[^0-9A-Za-z]/, '').downcase
      end

      def generate_filename(query_string)
        Digest::SHA1.hexdigest(query_string).concat(REPEXT)
      end

      def reports_path
        ::File.join(@path, REPDIR)
      end
    end
  end
end
