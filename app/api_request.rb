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
		if NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleDisplayName") == "Cardinal"
			@api_url = "http://webapi.enduraproducts.com/api/endura"
		elsif NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleDisplayName") == "Cardinal Dev"
			@api_url = "http://webapidev.enduraproducts.com/api/endura"
		else
			# @api_url = "http://localhost:3000/api/endura"
			@api_url = "http://webapidev.enduraproducts.com/api/endura"
		end

		if type == "login"
		  "#{@api_url}/login"
		elsif type == "validate_printer"
			"#{@api_url}/validate_printer"
		elsif type.downcase.match(/skid_label/) != nil || type.downcase.match(/print_label/) != nil
			"#{@api_url}/cardinal_printing/#{type.downcase.gsub(" ", "_")}"	
		elsif type == "get_tag_info"
			"#{@api_url}/get_tag_info"
		else
		 	"#{@api_url}/transactions/#{type.downcase.match(/\w+/)[0]}"
		end
	end

end