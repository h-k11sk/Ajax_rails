#
# This file is part of ruby-ffi.
# For licensing, see LICENSE.SPECS
#

require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))
require 'ffi'

describe "async callback" do
  module LibTest
    extend FFI::Library
    ffi_lib TestLibrary::PATH
    AsyncIntCallback = callback [ :int ], :void

    @blocking = true
    attach_function :testAsyncCallback, [ AsyncIntCallback, :int ], :void
  end

  it ":int (0x7fffffff) argument" do
    v = 0xdeadbeef
    called = false
    cb = Proc.new {|i| v = i; called = true }
    LibTest.testAsyncCallback(cb, 0x7fffffff) 
    called.should be_true
    v.should == 0x7fffffff
  end
  
  it "called a second time" do
    v = 0xdeadbeef
    called = false
    cb = Proc.new {|i| v = i; called = true }
    LibTest.testAsyncCallback(cb, 0x7fffffff) 
    called.should be_true
    v.should == 0x7fffffff
  end
end
