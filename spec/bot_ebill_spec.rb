RSpec.describe BotEbill do
  it "has a version number" do
    expect(BotEbill::VERSION).not_to be nil
  end
  before(:all) do 
  	@collection_no = "700602"
  	@store_no = "6II"
  	@order_no = "000046271"
  	@price = "14520"
  end
  describe "檢核碼" do 
	  it "台銀" do 
	  	expect(BotEbill::CheckCode.bot(collection_no: @collection_no, order_no: @order_no, price: @price)).to eq(1)
	  end

	  it "超商" do 
	  	section_1 = "991231Y01"
	  	section_2 = "ABCDEFGHIKLMNPQR"
	  	section_3 = "1234000007890"
	  	expect(BotEbill::CheckCode.store(section_1, section_2, section_3)).to eq("9Y")
	  end

	  it "郵局" do 
	  	@order_no = "201146271"
	  	expect(BotEbill::CheckCode.post_office(collection_no: @collection_no, order_no: @order_no, price: @price)).to eq(2)
	  end
	end

	describe "必填" do

		it "代收類別 collection_no" do
			expect{BotEbill::BarcodeText.new(order_no: @order_no, price: @price, store_no: @store_no)}.to raise_error(ArgumentError)
		end
		it "超商代收項目 store_no" do
			expect{BotEbill::BarcodeText.new(order_no: @order_no, price: @price, collection_no: @collection_no)}.to raise_error(ArgumentError)
		end
		it "自訂編號 order_no" do
			expect{BotEbill::BarcodeText.new(price: @price, collection_no: @collection_no, store_no: @store_no)}.to raise_error(ArgumentError)
		end
		it "金額 price" do
			expect{BotEbill::BarcodeText.new(order_no: @order_no, collection_no: @collection_no, store_no: @store_no)}.to raise_error(ArgumentError)
		end
	end

	describe "產出條碼" do 
		before do 
			@barcode_text = BotEbill::BarcodeText.new(order_no: @order_no, collection_no: @collection_no, store_no: @store_no, price: @price)
		end
		
		it "台銀" do 
			expect(@barcode_text.bot_text).to eq(["7006020000462711", "14520"])
		end 

		it "超商" do 
			expect(@barcode_text.store_text).to eq(["9999996II", "7006020000462711", "1234A4000014520"])
		end

		it "郵局" do 
			expect(@barcode_text.post_office_text).to eq(["19834251", "7006020000462714", "14535"])
		end
	end
end
