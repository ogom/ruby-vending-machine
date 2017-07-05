describe MoneyStore do
  let(:money_10_yen_coin){ Money.new("10円玉") }
  let(:money_50_yen_coin){ Money.new("50円玉") }
  let(:money_100_yen_coin){ Money.new("100円玉") }
  let(:money_500_yen_coin){ Money.new("500円玉") }
  let(:money_1000_yen_bill){ Money.new("1000円札") }
  let(:money_store){ MoneyStore.new }

  describe "reducer" do
    describe "insert" do
      context "first" do
        let(:state){ {moneys: [], amount: 0} }
        let(:action){ {type: :insert, payload: money_10_yen_coin} }
        subject { money_store.send(:reducer, state, action) }
        it { is_expected.to match a_hash_including(moneys: [money_10_yen_coin]) }
        it { is_expected.to match a_hash_including(amount: 10) }
      end

      context "append" do
        let(:state){ {moneys: [money_10_yen_coin], amount: 10} }
        let(:action){ {type: :insert, payload: money_50_yen_coin} }
        subject { money_store.send(:reducer, state, action) }
        it { is_expected.to match a_hash_including(moneys: [money_50_yen_coin, money_10_yen_coin]) }
        it { is_expected.to match a_hash_including(amount: 60) }
      end
    end

    describe "eject" do
      let(:state){ {moneys: [money_100_yen_coin, money_10_yen_coin], amount: 110} }
      let(:action){ {type: :eject, payload: state[:amount]} }
      subject { money_store.send(:reducer, state, action) }
      it { is_expected.to match a_hash_including(moneys: [], amount: 0) }
    end
  end

  describe "dispatch" do
    describe "insert" do
      example do
        expect(money_store).to receive(:dispatch).with({:type=>:insert, :payload=>money_10_yen_coin})
        money_store.insert(money_10_yen_coin)
      end
    end

    describe "eject" do
      example do
        expect(money_store).to receive(:dispatch).with({:type=>:eject, :payload=>"10円玉"})
        money_store.eject(money_10_yen_coin.name)
      end
    end
  end
end
