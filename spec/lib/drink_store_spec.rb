describe DrinkStore do
  let(:drink_coke){ Drink.new("コーラ", 120) }
  let(:drink_store){ DrinkStore.new }

  describe "reducer" do
    describe "insert" do
      let(:state){ {drinks: []} }
      let(:action){ {type: :insert, payload: drink_coke} }
      subject { drink_store.send(:reducer, state, action) }
      it { is_expected.to match a_hash_including(drinks: [drink_coke]) }
    end

    describe "eject" do
      let(:state){ {drinks: [drink_coke]} }
      let(:action){ {type: :eject, payload: drink_coke.name} }
      subject { drink_store.send(:reducer, state, action) }
      it { is_expected.to match a_hash_including(drinks: []) }
    end
  end

  describe "dispatch" do
    describe "insert" do
      example do
        expect(drink_store).to receive(:dispatch).with({:type=>:insert, :payload=>drink_coke})
        drink_store.insert(drink_coke)
      end
    end

    describe "eject" do
      example do
        expect(drink_store).to receive(:dispatch).with({:type=>:eject, :payload=>"コーラ"})
        drink_store.eject(drink_coke.name)
      end
    end
  end
end
