require "spec_helper"

describe String do
  describe "#<<" do
    example "appends a character" do
      s = "ABC"
      s << "D"
      expect(s.size).to eq(4)
    end
    example "appends nil" , :exception do
      #pending "under investgating"
      s = "ABC"
      #s << nil
      #expect(s.size).to eq(4)
      expect { s << nil }.to raise_error(TypeError)
    end
  end
end
