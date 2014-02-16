require File.expand_path('../spec_helper', __FILE__)

describe GivenFilesystem do

  include GivenFilesystemSpecHelpers

  context "not initialized" do
    describe "#given_directory" do
      it "raises error" do
        expect{ given_directory }.to raise_error /given_filesystem/
      end
    end
    
    describe "#given_file" do
      it "raises error" do
        expect{ given_directory }.to raise_error /given_filesystem/
      end
    end
  end
  
  context "using the module" do
    use_given_filesystem

    describe "#given_directory" do
      it "creates unnamed directory" do
        path = given_directory
        expect( File.exists? path ).to be_true
        expect( File.directory? path ).to be_true
      end
      
      it "creates directory" do
        path = given_directory "hello"
        expect( path ).to match /\/hello$/      
      end
      
      it "creates nested directory" do
        path = nil
        given_directory "hello" do
          path = given_directory "world"
        end
        expect( path ).to match /\/hello\/world$/
      end
    end

    describe "#given_file" do
      it "creates unnamed dummy file" do
        path = given_dummy_file
        expect( File.exists? path ).to be_true
        expect( File.directory? path ).to be_false
      end
      
      it "creates named dummy file" do
        path = given_dummy_file "welcome"
        expect( path ).to match /\/welcome$/
        expect( File.exists? path ).to be_true
        expect( File.directory? path ).to be_false
      end

      it "creates file with content" do
        path = given_file "testcontent"
        expect( path ).to match /\/testcontent$/
        expect( File.read( path ) ).to eq "This is my test content.\n"
      end
      
      it "creates file with content and given filename" do
        path = given_file "welcome", :from => "testcontent"
        expect( path ).to match /\/welcome$/
        expect( File.read( path ) ).to eq "This is my test content.\n"
      end
      
      it "creates file in directory" do
        path = nil
        given_directory "hello" do
          path = given_file "world", :from => "testcontent"
        end
        expect( File.exists? path ).to be_true
        expect( File.read( path ) ).to eq "This is my test content.\n"
      end
    end
  end

end
