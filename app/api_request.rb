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
		#if RUBYMOTION_ENV == "test" || RUBYMOTION_ENV == "development"
			#@api_url = "http://webapidev.enduraproducts.com/api/endura"
		#else
		@api_url = "http://webapi.enduraproducts.com/api/endura"
		#end
		#@api_url = "http://localhost:3000/api/endura"

		if type == "login"
		  "#{@api_url}/login"
		elsif type.downcase.match(/label/) != nil
			"#{@api_url}/cardinal_printing/#{type.downcase.gsub(" ", "_")}"	
		else
		 	"#{@api_url}/transactions/#{type.downcase.match(/\w+/)[0]}"
		end
	end

end