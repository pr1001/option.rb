require 'singleton'

def Option val
  (not val.nil?) ? Some.new(val) : None
end

class Option
  include Enumerable
end

class None < Option
  include Singleton
  
  def get
    raise "None has no value"
  end
  
  # can either take a normal argument or a block if laziness is desired
  def self.getOrElse *args
    if not args.empty?
      args.first
    else
      yield if block_given?
    end
  end
  
  def self.each &block
    self
  end
  
  def self.map &block
    self
  end
  
  def self.flatMap &block
    self
  end
  
  def self.filter &block
    self
  end
  
  # FIXME: thinks that filter is a private method when I do this:
  class << self
    # compatible with Ruby's stupid standards
    alias_method :select, :filter
  end
end

def Some val
  Some.new val
end

class Some < Option
  def initialize val
    @val = val  
  end
  
  def get
    @val
  end
  
  # can either take a normal argument or a block if laziness is desired
  def getOrElse *args
    @val
  end
  
  def each &block
    block.call(@val)
  end
  
  def map &block
    Some.new(block.call(@val))
  end
  
  def flatMap &block
    r = block.call(@val)
    if r.is_a?(Some) or r.is_a?(None)
      r
    else
      raise "Did not return an Option"
    end
  end
  
  def filter &block
    r = block.call(@val)
    r ? self : None
  end
  # compatible with Ruby's stupid standards
  alias_method :select, :filter
end