class APIRequest

	def get(type=nil, params=nil, &block)
		url = getUrl(type)

		AFMotion::JSON.get("#{url}", params) do |result|
			if result.success?
				result = BW::JSON.parse(result.body)
				block.call(result)
		  elsif result.failure?    
		    block.call({success: false, error: result.error.localizedDescription})
		  end
		end
	end

	def getUrl(type)
		if type == "login"
		  "http://webapi.enduraproducts.com/api/endura/login"
		elsif type.downcase.match(/label/) != nil
			"http://webapi.enduraproducts.com/api/endura/cardinal_printing/#{type.downcase.gsub(" ", "_")}"	
		else
		 	"http://webapi.enduraproducts.com/api/endura/transactions/#{type.downcase.match(/\w+/)[0]}"
		end
	end

end