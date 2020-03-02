require 'digest'
require 'fileutils'
require 'memory_profiler'
require 'rack'

module Rack
  module MemProf
    class Middleware
      REPEXT = '.txt'.freeze
      REPDIR = 'rack_mem_prof'.freeze
      UNSLUGGABLE = 'stub_for_unslaggable_requests'.freeze

      def initialize(app, options = {})
        @app = app
        @path = options[:path] || "/tmp"
        @scale_bytes = options[:scale_bytes] || true
      end

      def call(env)
        report_path, report_filename = build_report_path(env)
        path_with_file = ::File.join(report_path, report_filename)

        if ::File.exists?(path_with_file)
          status, headers, body = @app.call(env)
        else
          FileUtils.mkdir_p report_path

          MemoryProfiler.start

          status, headers, body = @app.call(env)

          write_report(MemoryProfiler.stop, path_with_file)
        end

        [status, headers, body]
      rescue => e
        MemoryProfiler.stop
        raise e
      end

      private

      # report to "/tmp/rack_mem_prof/<request path>/<query params sha1>.txt"
      def write_report(report, path)
        report.pretty_print(
          scale_bytes: @scale_bytes,
          to_file: path,
        )
      end

      def build_report_path(env)
        return generate_path(env['PATH_INFO']), generate_filename(env['QUERY_STRING'])
      end

      def generate_path(path_info)
        dirname_for_request = generate_dirname(path_info)
        ::File.join(reports_path, dirname_for_request)
      end

      def generate_dirname(path_info)
        dirname = path_info.gsub(/[^0-9A-Za-z]/, '').downcase

        return UNSLUGGABLE if dirname.length.zero?
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
