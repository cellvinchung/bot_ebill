module BotEbill
	class CheckCode

		def self.bot(options)
			collection_no = options[:collection_no].to_s #代收類別
			order_no = options[:order_no].to_s #自訂編號
			price = options[:price].to_s #金額
			
			full_price = price.to_s.rjust(10, "0")

			full_string = "#{collection_no}#{order_no}#{full_price}"
			weights = [1,3,7]

			full_string.split("").each_with_index.map{|element, index| element.to_i*(weights[index%3]) }.reduce(&:+)%10
		end

		def self.store(section_1, section_2, section_3) #超商檢核碼
			numbered_section_1 = section_1.split("").map{|s| transfer_text(s)}
			numbered_section_2 = section_2.split("").map{|s| transfer_text(s)}
			numbered_section_3 = section_3.split("").map{|s| transfer_text(s)}

			numbered_section_1_odd, numbered_section_1_even = numbered_section_1.partition.with_index { |_,i| i.even? }
			numbered_section_2_odd, numbered_section_2_even = numbered_section_2.partition.with_index { |_,i| i.even? }
			numbered_section_3_odd, numbered_section_3_even = numbered_section_3.partition.with_index { |_,i| i.even? }

			first_sum = (numbered_section_1_odd+numbered_section_2_odd+numbered_section_3_odd).reduce(&:+)
			last_sum = (numbered_section_1_even+numbered_section_2_even+numbered_section_3_even).reduce(&:+)

			first_code, last_code = first_sum%11, last_sum%11
			first_code = "A" if first_code == 0
			first_code = "B" if first_code == 10
			last_code = "X" if last_code == 0
			last_code = "Y" if last_code == 10

			"#{first_code}#{last_code}"
		end

		def self.post_office(options) #郵局檢核碼
			collection_no = options[:collection_no].to_s #代收類別
			order_no = options[:order_no].to_s #自訂編號
			price = options[:price].to_s #金額
			
			full_price = price.to_s.rjust(10, "0")

			full_string = "#{collection_no}#{order_no}#{full_price}"
			weights = [1,3,7]

			code = full_string.split("").each_with_index.map{|element, index| element.to_i*(weights[index%3]) }.reduce(&:+)%10

			code + 1
		end

		private

		def self.transfer_text(text)
			text_mapping = {
				A: 1,
				B: 2,
				C: 3,
				D: 4,
				E: 5,
				F: 6,
				G: 7,
				H: 8,
				I: 9,
				J: 1,
				K: 2,
				L: 3,
				M: 4,
				N: 5,
				O: 6,
				P: 7,
				Q: 8,
				R: 9,
				S: 2,
				T: 3,
				U: 4,
				V: 5,
				W: 6,
				X: 7,
				Y: 8,
				Z: 9
			}
			text = text.to_s.upcase

			text.between?("A", "Z") ? text_mapping[text.to_sym] : text.to_i
		end
	end
end