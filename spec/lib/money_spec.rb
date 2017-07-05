shared_examples "valid money" do |name, value|
  subject { Money.new(name) }

  example "value of #{name} is #{value}" do
    expect(subject.value).to eq value
  end

  example "#{name} is valid" do
    expect(subject.valid?).to be_truthy
  end
end

shared_examples "invalid money" do |name|
  subject { Money.new(name) }

  example "value of #{name} is 0" do
    expect(subject.value).to eq 0
  end

  example "#{name} is invalid" do
    expect(subject.valid?).to be_falsey
  end
end

describe Money do
  context "valid money" do
    describe "10 yen coin" do
      include_examples "valid money", "10円玉", 10
    end

    describe "50 yen coin" do
      include_examples "valid money", "50円玉", 50
    end

    describe "100 yen coin" do
      include_examples "valid money", "100円玉", 100
    end

    describe "500 yen coin" do
      include_examples "valid money", "500円玉", 500
    end

    describe "1000 yen bill" do
      include_examples "valid money", "1000円札", 1000
    end
  end

  context "invalid money" do
    describe "1 yen coin" do
      include_examples "invalid money", "1円玉"
    end

    describe "5 yen coin" do
      include_examples "invalid money", "5円玉"
    end

    describe "2000 yen bill" do
      include_examples "invalid money", "2000円札"
    end

    describe "5000 yen bill" do
      include_examples "invalid money", "5000円札"
    end

    describe "10000 yen bill" do
      include_examples "invalid money", "10000円札"
    end
  end
end
