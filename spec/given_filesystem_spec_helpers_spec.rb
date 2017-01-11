require_relative 'spec_helper'

describe GivenFilesystemSpecHelpers do

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

  context "with keeping of files enabled" do
    use_given_filesystem :keep_files => true

    it "creates directories" do
      path = given_directory "hello"
      expect( File.exists? path ).to be(true)

      # Manually clean up, so test doesn't leave files around
      @__given_filesystem.cleanup
    end
  end

  context "using the module" do
    use_given_filesystem

    context "in around filters" do
      around(:each) do |example|
        given_directory
        example.run
      end

      it "works" do
        expect(true).to be true
      end
    end

    describe "#given_directory" do
      it "creates unnamed directory" do
        path = given_directory
        expect( File.exists? path ).to be(true)
        expect( File.directory? path ).to be(true)
      end

      it "creates directory" do
        path = given_directory "hello"
        expect( path ).to match /\/hello$/
      end

      it "creates entire directory structure" do
        path = given_directory "some/directory/structure"
        expect( path ).to match /\/some$/
      end

      it "creates nested directory" do
        path = nil
        given_directory "hello" do
          path = given_directory "world"
        end
        expect( path ).to match /\/hello\/world$/
      end
    end

    describe "#give_directory_from_data" do
      it "creates directory with content from data" do
        path = given_directory_from_data "welcome"
        expect( path ).to match /\/welcome$/
      end

      it "creates directory with content from named data" do
        path = given_directory_from_data "hi", :from => "welcome"
        expect( path ).to match /\/hi$/
      end
    end

    describe "#given_dummy_file" do
      it "creates unnamed dummy file" do
        path = given_dummy_file
        expect( File.exists? path ).to be(true)
        expect( File.directory? path ).to be(false)
      end

      it "creates named dummy file" do
        path = given_dummy_file "welcome"
        expect( path ).to match /\/welcome$/
        expect( File.exists? path ).to be(true)
        expect( File.directory? path ).to be(false)
      end
    end

    describe "#given_file" do
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
        expect( File.exists? path ).to be(true)
        expect( File.read( path ) ).to eq "This is my test content.\n"
      end
    end
  end

end
