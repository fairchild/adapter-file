# require "adapter-file/version"
require 'adapter'
require 'find'
require 'fileutils'

module Adapter
  module File

    def initialize(client, options={})
     base_directory(client)  # this will be the base directory
     paths = ::File.split(key)
     FileUtils.mkdir_p(paths.first) unless ::File.directory?(paths.first)
   end
           
    def base_directory(root='./')
      @base_directory ||= ::File.expand_path(client)
    end
    
    def full_key(key)
      raise "you are not allowed to use double dot '..' notation in paths" if key.match(/\.\.\//)
      ::File.expand_path(::File.join(base_directory, key))
    end
    
    # does the file already exist?
    def key?(key)
      raise "you are not allowed to use double dot '..' notation in paths" if key.match(/\.\.\//)
      ::File.exists?(full_key(key))
    end
    
    def keys
      files=[]
      ::Find.find(base_directory) do |item|
        files << item[(base_directory.length)..-1] if ::File.file?(item)
      end
      files
    end

    def read(key)
      ::File.read(full_key(key))
    end

    def write(key, value)
      paths = ::File.split(full_key(key))
      FileUtils.mkdir_p(paths.first) unless ::File.directory?(paths.first)
      f = ::File.open(full_key(key), 'w') {|f| f.write(value) }
    end

    def delete(key, options={:recursive=>false})      
      if ::File.file?(full_key(key))
        ::File.delete(full_key(key))
      elsif ::File.directory?(full_key(key))
        ::FileUtils.rm(full_key(key)) unless options[:recursive]
        ::FileUtils.rm_r(full_key(key)) if options[:recursive]
      else
        raise 'unknown error'
      end
    end

    def clear
      delete('', {:recursive=>true})
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
