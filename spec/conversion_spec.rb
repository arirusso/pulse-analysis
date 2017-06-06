require "helper"

describe PulseAnalysis::Conversion do

  before(:each) do
    @sample_rate = 88200
  end

  context ".num_samples_to_formatted_time" do

    context "less than a minute" do

      context "int seconds" do

        before(:each) do
          @num_samples = 88200 * 16
          @result = PulseAnalysis::Conversion.num_samples_to_formatted_time(@sample_rate, @num_samples)
        end

        it "returns result" do
          expect(@result).to_not(be_nil)
        end

        it "has correct result" do
          expect(@result).to(eq("16s"))
        end

      end

      context "float seconds" do

        before(:each) do
          @num_samples = 88200 * 59.9
          @result = PulseAnalysis::Conversion.num_samples_to_formatted_time(@sample_rate, @num_samples)
        end

        it "returns result" do
          expect(@result).to_not(be_nil)
        end

        it "has correct result" do
          expect(@result).to(eq("59.9s"))
        end

      end

    end

    context "more than a minute" do

      context "int seconds" do

        before(:each) do
          @num_samples = 88200 * 67
          @result = PulseAnalysis::Conversion.num_samples_to_formatted_time(@sample_rate, @num_samples)
        end

        it "returns result" do
          expect(@result).to_not(be_nil)
        end

        it "has correct result" do
          expect(@result).to(eq("1m7s"))
        end

      end

      context "float seconds" do

        before(:each) do
          @num_samples = 88200 * 223.821
          @result = PulseAnalysis::Conversion.num_samples_to_formatted_time(@sample_rate, @num_samples)
        end

        it "returns result" do
          expect(@result).to_not(be_nil)
        end

        it "has correct result" do
          expect(@result).to(eq("3m43.82s"))
        end

      end

    end

  end

  context ".num_samples_to_millis" do

    context "float" do

      before(:each) do
        @num_samples = 88200 * 2.3
        @result = PulseAnalysis::Conversion.num_samples_to_millis(@sample_rate, @num_samples)
      end

      it "returns result" do
        expect(@result).to_not(be_nil)
      end

      it "has correct result" do
        expect(@result).to(eq(2300))
      end

    end

    context "int" do

      before(:each) do
        @num_samples = 88200 * 17.34567810
        @result = PulseAnalysis::Conversion.num_samples_to_millis(@sample_rate, @num_samples)
      end

      it "returns result" do
        expect(@result).to_not(be_nil)
      end

      it "has correct result" do
        expect(@result).to(eq(17345.6781))
      end

    end

  end

  context ".num_samples_to_seconds" do

    context "float" do

      before(:each) do
        @num_samples = 88200 * 4.3
        @result = PulseAnalysis::Conversion.num_samples_to_seconds(@sample_rate, @num_samples)
      end

      it "returns result" do
        expect(@result).to_not(be_nil)
      end

      it "has correct result" do
        expect(@result).to(eq(4.3))
      end

    end

    context "int" do

      before(:each) do
        @num_samples = 88200 * 12
        @result = PulseAnalysis::Conversion.num_samples_to_seconds(@sample_rate, @num_samples)
      end

      it "returns result" do
        expect(@result).to_not(be_nil)
      end

      it "has correct result" do
        expect(@result).to(eq(12))
      end

    end

  end

end
