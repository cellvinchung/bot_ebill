module BotEbill
	class BarcodeText
		attr_accessor :bot_text, :store_text, :post_office_text
		def initialize(options)
			raise ArgumentError, 'Missing required argument: collection_no.代收類別' unless options[:collection_no]
			raise ArgumentError, 'Missing required argument: store_no.超商代收項目' unless options[:store_no]
			raise ArgumentError, 'Missing required argument: order_no.自訂編號' unless options[:order_no]
			raise ArgumentError, 'Missing required argument: price.金額' unless options[:price]
			
			@collection_no = options[:collection_no].to_s #代收類別
			@store_no = options[:store_no].to_s #超商代收項目
			@order_no = options[:order_no].to_s #自訂編號
			@price = options[:price] #金額

			bot_check_code = BotEbill::CheckCode.bot(collection_no: @collection_no, order_no: @order_no, price: @price)
			
			@bot_account = "#{@collection_no}#{@order_no}#{bot_check_code}" #台銀帳號
		end

		def bot_text #台銀條碼
			[@bot_account, @price.to_s]
		end

		def store_text
			section_1 = "999999#{@store_no}"
			section_2 = @bot_account
			
			custom_no = "1234"
			full_price = @price.to_s.rjust(9, "0")
			tem_section_3 = "#{custom_no}#{full_price}"

			store_check_code = BotEbill::CheckCode.store(section_1, section_2, tem_section_3)

			section_3 = "#{custom_no}#{store_check_code}#{full_price}"
			[section_1, section_2, section_3]
		end

		def post_office_text
			section_1 = "19834251" #固定台銀戶名

			total_price = @price.to_i + post_office_fee

			post_office_check_code = BotEbill::CheckCode.post_office(collection_no: @collection_no, order_no: @order_no, price: total_price)

			section_2 = "#{@collection_no}#{@order_no}#{post_office_check_code}"
			section_3 = total_price.to_s

			[section_1, section_2, section_3]
		end

		private

		def post_office_fee
			origin_price = @price.to_i
	  	fee = 5 if origin_price.between?(1, 95)
	  	fee = 10 if origin_price.between?(96, 990)
	  	fee = 15 if origin_price >= 991

	  	fee ||= 0
		end
	end
end