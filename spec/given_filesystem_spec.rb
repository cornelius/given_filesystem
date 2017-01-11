require_relative 'spec_helper'

describe GivenFilesystem do

  before(:each) do
    @given = GivenFilesystem.new
  end

  after(:each) do
    @given.cleanup
  end

  it "creates directory" do
    path = @given.directory
    expect( File.exists? path ).to be(true)
    expect( File.directory? path ).to be(true)
    expect( path ).to match /tmp/
    expect( path.split("/").length).to be > 3
  end

  it "creates nested unnamed directories" do
    nested_path = nil
    path = @given.directory do
      nested_path = @given.directory
    end
    expect( File.exists? nested_path ).to be(true)
    expect( nested_path.split("/").count ).to eq path.split("/").count + 1
  end

  it "creates named directory" do
    path = @given.directory "abc"
    expect( File.exists? path ).to be(true)
    expect( path ).to match /tmp/
    expect( path.split("/").length).to be > 4
    expect( path ).to match /abc$/
  end

  it "creates named directory including path" do
    path = @given.directory "abc"
    deep_path = @given.directory "x/y/z"
    expect( File.exists? deep_path ).to be(true)
    expect( File.directory? deep_path ).to be(true)
    expect( deep_path.split("/").count ).to eq path.split("/").count
  end

  it "creates file" do
    path = @given.file
    expect( path ).to match /tmp/
    expect( path.split("/").length).to be > 3
    expect( File.exists? path ).to be(true)
    expect( File.directory? path ).to be(false)
  end

  it "creates named file" do
    path = @given.file "def"
    expect( path ).to match /tmp/
    expect( path.split("/").length).to be > 4
    expect( path ).to match /def$/
  end

  it "creates named file including path" do
    path = @given.file "def"
    deep_path = @given.file "x/y/z"
    expect( File.exists? deep_path ).to be(true)
    expect( File.directory? deep_path ).to be(false)
    expect( deep_path.split("/").count ).to eq path.split("/").count + 2
  end

  it "throws error on invalid test data file name" do
    expect{@given.file "def", :from => "invalidname"}.to raise_error /invalidname/
  end

  it "creates file with content" do
    path = @given.file "def", :from => "testcontent"
    expect( path ).to match /tmp/
    expect( path.split("/").length).to be > 4
    expect( path ).to match /def$/
    expect( File.read(path) ).to eq "This is my test content.\n"
  end

  it "creates directory tree" do
    path = @given.directory do
      @given.directory "one" do
        @given.file "first"
      end
      @given.directory "two" do
        @given.file "second"
        @given.file "third"
      end
    end

    expect( File.exists? path).to be(true)
    expect( File.directory? path).to be(true)
    expect( File.exists? File.join(path,"one")).to be(true)
    expect( File.exists? File.join(path,"one")).to be(true)
    expect( File.directory? File.join(path,"one")).to be(true)
    expect( File.directory? File.join(path,"two")).to be(true)
    expect( File.exists? File.join(path,"one","first")).to be(true)
    expect( File.exists? File.join(path,"two","second")).to be(true)
    expect( File.exists? File.join(path,"two","third")).to be(true)
  end

  it "creates flat sub directories with data" do
    path = @given.directory do
      @given.directory_from_data "welcome"
      @given.directory_from_data "hello"
    end

    expect(File.directory? File.join(path,"welcome")).to be(true)
    expect(File.directory? File.join(path,"hello")).to be(true)
  end

  it "creates directory from data" do
    path = @given.directory_from_data( "welcome" )
    expect( path ).to match /\/welcome$/
    expect( File.exists? path ).to be(true)
    expect( File.directory? path ).to be(true)

    expect( File.exist? File.join( path, "universe" ) ).to be(true)
    expect( File.directory? File.join( path, "universe" ) ).to be(false)
    expect( File.read( File.join( path, "universe" ) ) ).to eq "I was here\n"

    expect( File.exist? File.join( path, "space" ) ).to be(true)
    expect( File.directory? File.join( path, "space" ) ).to be(true)
  end

  it "creates directory from data under different name" do
    path = @given.directory_from_data( "hi", "welcome" )
    expect( path ).to match /\/hi$/
    expect( File.exists? path ).to be(true)
    expect( File.directory? path ).to be(true)

    expect( File.exist? File.join( path, "universe" ) ).to be(true)
    expect( File.directory? File.join( path, "universe" ) ).to be(false)
    expect( File.read( File.join( path, "universe" ) ) ).to eq "I was here\n"

    expect( File.exist? File.join( path, "space" ) ).to be(true)
    expect( File.directory? File.join( path, "space" ) ).to be(true)
  end

  it "returns paths" do
    path1 = @given.directory "one"
    expect( path1 ).to match /^\/tmp\/given_filesystem\/[\d-]+\/one$/

    path2 = @given.directory "two"
    expect( path2 ).to match /^\/tmp\/given_filesystem\/[\d-]+\/two$/

    path3 = @given.directory "three" do
      @given.file "first"
    end
    expect( path3 ).to match /^\/tmp\/given_filesystem\/[\d-]+\/three$/
  end

  it "cleans up directory tree" do
    given = GivenFilesystem.new
    path1 = given.directory
    path2 = given.directory

    expect( File.exists? path1).to be(true)
    expect( File.exists? path2).to be(true)

    given.cleanup

    expect( File.exists? path1).to be(false)
    expect( File.exists? path2).to be(false)
  end

end
