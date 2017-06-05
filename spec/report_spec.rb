require "helper"

describe PulseAnalysis::Report do

  before(:each) do
    @media = File.join("spec", "media", "roland_r5_audioout_120bpm_88k.wav")
    @analysis = PulseAnalysis::Analysis.new(@media)
    @analysis.run
    @report = PulseAnalysis::Report.new(@analysis)
  end

  context "#to_h" do

    before(:each) do
      @result = @report.to_h
    end

    it "populates hash" do
      expect(@result).to_not(be_nil)
    end

    it "has file node" do
      expect(@result[:file]).to_not(be_nil)
    end

    it "has anaysis node" do
      expect(@result[:analysis]).to_not(be_nil)
    end

    it "has analysis items" do
      expect(@result[:analysis]).to_not(be_empty)
    end

    it "has analysis item values" do
      items = @result[:analysis]
      values = items.map { |item| item[:value] }
      expect(values).to(
        all(
          be_kind_of(Array).
            or(be_kind_of(Hash)
          )
        )
      )
    end

  end

  context "#inspect" do

    it "doesn't use Object#inspect" do
      expect(@report.inspect).to(eq(@report.to_h.to_s))
    end

  end

end
