describe Drink do
  let(:drink){ Drink.new("コーラ", 120) }

  describe "#to_h" do
    subject { drink.to_h }
    it { is_expected.to a_hash_including(:name=>"コーラ", :price=>120) }
  end
end
