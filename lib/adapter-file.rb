# require "adapter-file/version"
require 'adapter'
require 'find'
require 'fileutils'

module Adapter
  module File

    def initialize(client, options={})
     @client = client  # this will be the base directory
   end
           
    def base_directory(root='./')
      @base_directory ||= ::File.expand_path(client)
    end
    # does the file already exist?
    def key?(key)
      ::File.exists?(key)
    end
    
    def keys
      files=[]
      ::Find.find(base_directory) do |item|
        files << item[(base_directory.length)..-1] if ::File.file?(item)
      end
      files
    end

    def read(key)
      ::File.read(key)
    end

    def write(key, value)
      paths = ::File.split(key)
      raise "you are not allowed to use double dot '..' notation in paths" if key.match(/\.\.\//)
      FileUtils.mkdir_p(paths.first) unless ::File.directory?(paths.first)
      f = ::File.open(key, 'w') {|f| f.write(value) }
    end

    def delete(key, options={:recursive=>false})      
      if ::File.file?(key)
        puts "file #{key}"
        ::File.delete(key)
      elsif ::File.directory?(key)
        ::FileUtils.rm(key) unless options[:recursive]
        ::FileUtils.rm_r(key) if options[:recursive]
        end
      else
        raise 'unknown error'
      end
    end

    def clear
      Dir.foreach(base_directory) do |item|
         if ::File.file?(item)
           puts "file #{item}"
           ::File.delete(item)
         else
           puts "#{item } is not a file"
         end
      end
     
    end

    def encode(value)
      value
    end

    def decode(value)
      value
    end

    Adapter.define(:file, Adapter::File)
    
  end
end
