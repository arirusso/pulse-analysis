require "helper"
require "pulse-analysis/console"

describe PulseAnalysis::Console::Table do

  before(:each) do
    @media = File.join("spec", "media", "roland_r5_audioout_120bpm_88k.wav")
    @analysis = PulseAnalysis::Analysis.new(@media)
    @analysis.run
    @report = PulseAnalysis::Report.new(@analysis)
  end

  context ".build" do

    before(:each) do
      @table = PulseAnalysis::Console::Table.build(@report)
    end

    it "returns table object" do
      expect(@table).to_not(be_nil)
      expect(@table).to(be_kind_of(PulseAnalysis::Console::Table))
    end

    it "populates table" do
      expect(@table.content).to_not(be_nil)
      expect(@table.content).to(be_kind_of(::Terminal::Table))
    end

  end

  context "#build" do

    before(:each) do
      @table = PulseAnalysis::Console::Table.new(@report)
      @table.build
    end

    it "populates table" do
      expect(@table.content).to_not(be_nil)
      expect(@table.content).to(be_kind_of(::Terminal::Table))
    end

    it "has the correct amount of rows" do
      expect(@table.content.rows).to_not(be_nil)
      expect(@table.content.rows).to_not(be_empty)
      expect(@table.content.rows.count).to(eq(@report.items.count))
    end

  end

end
