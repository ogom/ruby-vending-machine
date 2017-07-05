describe VendingMachine do
  let(:vending_machine){ VendingMachine.new }

  describe "insert money" do
    context "valid money" do
      before { vending_machine.insert_money("10円玉") }
      example { expect(vending_machine.state[:deposit_amount]).to eq 10 }
    end

    context "invalid money" do
      before { vending_machine.insert_money("1円玉") }
      example { expect(vending_machine.state[:change_moneys]).to eq ["1円玉"] }
    end
  end

  describe "eject money" do
    before {
      vending_machine.insert_money("10円玉")
      vending_machine.eject_money
    }

    example { expect(vending_machine.state[:deposit_amount]).to eq 0 }
    example { expect(vending_machine.state[:change_moneys]).to eq ["10円玉"] }
  end

  describe "sale drinks" do
    before {
      5.times { vending_machine.insert_drink("コーラ", 120) }
    }
    example { expect(vending_machine.state[:stock_drinks].count).to eq 5 }
    example { expect(vending_machine.state[:sale_drinks]).to match [a_hash_including(:name=>"コーラ", :price=>120)] }
  end

  describe "choose drinks" do
    before {
      5.times { vending_machine.insert_drink("コーラ", 120) }
    }

    context "insert 0 yen" do
      example { expect(vending_machine.state[:choose_drinks]).to eq [] }
    end

    context "insert 120 yen" do
      before {
        4.times { vending_machine.insert_money("10円玉") }
        2.times { vending_machine.insert_money("50円玉") }
      }
      example { expect(vending_machine.state[:choose_drinks]).to match [a_hash_including(:name=>"コーラ", :price=>120)] }

      describe "purchase drink" do
        before { vending_machine.purchase_drink("コーラ") }
        example { expect(vending_machine.state[:deposit_amount]).to eq 20 }
        example { expect(vending_machine.state[:stock_amount]).to eq 120 }
        example { expect(vending_machine.state[:stock_drinks].count).to eq 4 }

        describe "eject money" do
          before { vending_machine.eject_money }
          example { expect(vending_machine.state[:deposit_amount]).to eq 0 }
          example { expect(vending_machine.state[:change_moneys]).to eq ["10円玉", "10円玉"] }
        end
      end
    end
  end

  describe "purchase many drinks" do
    before {
      5.times { vending_machine.insert_drink("コーラ", 120) }
      5.times { vending_machine.insert_drink("レッドブル", 200) }
      5.times { vending_machine.insert_drink("水", 100) }
    }

    example { expect(vending_machine.state[:stock_drinks].count).to eq 15 }
    example { expect(vending_machine.state[:sale_drinks]).to match [
      a_hash_including(:name=>"コーラ", :price=>120),
      a_hash_including(:name=>"レッドブル", :price=>200),
      a_hash_including(:name=>"水", :price=>100)
    ] }

    describe "insert 10 yen" do
      before {
        1.times { vending_machine.insert_money("10円玉") }
      }
      example { expect(vending_machine.state[:choose_drinks]).to eq [] }

      describe "insert 90 yen" do
        before {
          4.times { vending_machine.insert_money("10円玉") }
          1.times { vending_machine.insert_money("50円玉") }
        }
        example { expect(vending_machine.state[:choose_drinks]).to match [a_hash_including(:name=>"水", :price=>100)] }

        describe "insert 20 yen" do
          before {
            2.times { vending_machine.insert_money("10円玉") }
          }
          example { expect(vending_machine.state[:choose_drinks]).to match [
            a_hash_including(:name=>"コーラ", :price=>120),
            a_hash_including(:name=>"水", :price=>100)
          ] }

          describe "insert 1100 yen" do
            before {
              11.times { vending_machine.insert_money("100円玉") }
            }
            example { expect(vending_machine.state[:choose_drinks]).to match [
              a_hash_including(:name=>"コーラ", :price=>120),
              a_hash_including(:name=>"レッドブル", :price=>200),
              a_hash_including(:name=>"水", :price=>100)
            ] }

            example { expect(vending_machine.state[:deposit_amount]).to eq 1220 }

            describe "purchase drink" do
              before { 
                5.times { vending_machine.purchase_drink("レッドブル") }
              }
              example { expect(vending_machine.state[:deposit_amount]).to eq 220 }
              example { expect(vending_machine.state[:choose_drinks]).to match [
                a_hash_including(:name=>"コーラ", :price=>120),
                a_hash_including(:name=>"水", :price=>100)
              ] }

              describe "purchase drink" do
                before { 
                  1.times { vending_machine.purchase_drink("コーラ") }
                  1.times { vending_machine.purchase_drink("水") }
                }
                example { expect(vending_machine.state[:deposit_amount]).to eq 0 }
                example { expect(vending_machine.state[:choose_drinks]).to match [] }

                describe "eject money" do
                  before { vending_machine.eject_money }
                  example { expect(vending_machine.state[:change_moneys]).to eq [] }
                end
              end
            end
          end
        end
      end
    end
  end
end
