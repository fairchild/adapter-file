# require "adapter-file/version"
require 'adapter'
require 'find'
require 'fileutils'
require 'adapter/file/version'

module Adapter
  module File

    def initialize(client='./files', options={})
      FileUtils.mkdir_p(client)# unless ::File.directory?(client)
      base_directory client  # this will be the base directory
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

    #return the file contents, or the directory listing if a directory
    def read(key)
      if ::File.file?(full_key(key))
        ::File.read(full_key(key))
      elsif  ::File.directory?(full_key(key))
        Dir.entries('.')[2..-1]  #don't return the . and .. directories
      end
    end
    
    #TODO implement fetch
    # def fetch(key)
    #   raise "not implemented yet.  will return value or passed default"
    # end

    def write(key, value)
      paths = ::File.split(full_key(key))
      FileUtils.mkdir_p(paths.first) unless ::File.directory?(paths.first)
      f = ::File.open(full_key(key), 'w') {|f| f.write(value) }
    end

    def delete(key, options={:recursive=>false})
      if key?(key)
        value=read(key)
        if ::File.file?(full_key(key))
          ::File.delete(full_key(key))
        elsif ::File.directory?(full_key(key))
          if options[:recursive]
          keys.each{|f| ::FileUtils.rm_r(full_key(f)) }
          else
            ::FileUtils.rm(full_key(key)) unless options[:recursive]
          end
        elsif !::File.directory?(full_key(key))
          true
        else
          raise 'unknown error'
        end
        value
      end
    end

    def clear
       delete('', {:recursive=>true}) 
      # if ::File.directory?(base_directory)
      #   delete('', {:recursive=>true}) 
      # else
      #   p [:client, client]
      #   p [:base_dir, base_directory,  ::File.directory?(base_directory)]
      # end
    end

    def encode(value)
      value
    end

    def decode(value)
      value
    end

    
    # private
    def base_directory(root='./')
      @base_directory ||= ::File.expand_path(client)
    end
    
    def full_key(key)
      raise "you are not allowed to use double dot '..' notation in paths" if key.match(/\.\.\//)
      ::File.expand_path(::File.join(base_directory,key_for(key)))
    end
    
    Adapter.define(:file, Adapter::File)
    
  end
end
