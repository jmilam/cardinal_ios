class MainMenuController < UIViewController

	def viewDidLoad

		@qad_env = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleDisplayName") == "Cardinal" ? "qadprod" : "qadnix"
		@qad_api = NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleDisplayName") == "Cardinal" ? "prodapi" : "testapi"
		self.title = 'Cardinal Functions'
		self.view.backgroundColor = UIColor.whiteColor
		self.automaticallyAdjustsScrollViewInsets = false

		search = UISearchBar.new
		search.delegate = self
		search.frame = [[self.view.frame.size.width - 300,-10],[200,50]]
		self.navigationController.navigationBar.addSubview(search)

		img = nil
		button = nil
		@po_items_count = 0

		@headers = {"Inventory Control" => ["PCT (Pallet Cycle Count)", "PDL (Pallet Delete)", "PLO (Pallet Load)", "PMV (Pallet Move)", "PUL (Pallet Unload)", "POR (Purchase Order Receipt)", "Inventory Detail by Item Browse"], "Manufacturing" => ["BKF (Backflush)"], "Label Printing" => ["TPT (Tag Reprint)", "GLB (General Label)", "Skid label"], "Distribution" => ["CAR (Carton Create)", "CTE (Carton Edit)", "SKD (Skid Create)", "SKE (Skid Edit)", "PICK (Shipping)", "VMI PICK"]}

		setInitialVariableValues

		super

	end

	def setInitialVariableValues
		@builder = ScreenBuilder.alloc.initWithView(self)
		@builder.buildMainMenu(self)
		@cell_bg = @builder.cell_bg
		@item_num = @builder.item_num
		@from_loc = @builder.from_loc
		@tag_num = @builder.tag_num
		@new_tag_num = @builder.new_tag_num
		@to_loc = @builder.to_loc
		@qty = @builder.qty
		@from_site = @builder.from_site
		@to_site = @builder.to_site
		@skid_num = @builder.skid_num
		@table = @builder.table
		@header = @builder.header
		@printer = @builder.printer
		@remarks = @builder.remarks
		@lot = @builder.lot
		@po_number = @builder.po_number
		@carton_num = @builder.carton_item
		@so_num = @builder.so_number
		@po_items = nil
		@carton_delete = @builder.carton_number
		@cartons = @builder.cartons
		@line_number = @builder.line_number
		@prod_line = @builder.prod_line
		@user_initials = @builder.user_initials
		@distribution_num = @builder.distribution_num
	end

	def submit
		@builder.clearAlertArea
		self.view.endEditing(true)
		showSpinner
		if @header.text.downcase.match(/glb/) != nil
			APIRequest.new.get("glb", {remarks: @remarks.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site , type: "#{@header.text.downcase}"}) do |result|
				@builder.updateAlertArea
				stopSpinner
			end
		elsif @header.text.downcase.match(/^tpt/) != nil
			APIRequest.new.get("print_label", {tag: @tag_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, user_id: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, trans_type: "tpt", type: "print_label"}) do |result|
				@builder.updateAlertArea
				stopSpinner
			end
		elsif @header.text.downcase.match(/^car/) != nil
			data = nil
			self.view.subviews.each {|subview| subview.class == UIScrollView ? data = subview : next}
			if data.nil?
				stopSpinner
			else
				data.subviews.each_with_index do |subview, index|
					unless subview.subviews.empty?
						unless subview.subviews[0].text.to_i <= 0
							APIRequest.new.get("car", {so: @so_num.text, line: @line_number.text, carton_box: @carton_num.text, pack_qty: subview.subviews[0].text, print: "N", prev_packed: subview.subviews[7].text , user: UIApplication.sharedApplication.delegate.username.downcase, printer:  UIApplication.sharedApplication.delegate.printer.downcase}) do |result|
							  clearSubViews
							  functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
							  @so_num.text = ""
							  @line_number.text = ""
							  @carton_num.text = ""
							  @builder.updateAlertArea
								@so_num.becomeFirstResponder
								stopSpinner
							end
						end
					end
				end


			end
			data = nil
		elsif @header.text.downcase.match(/^cte/) != nil
			alert = UIAlertController.alertControllerWithTitle("If you delete this carton, you won't be able to get it back. Are you sure you want to delete this carton?", message:  "",preferredStyle: UIAlertControllerStyleAlert)
			cancelAction = UIAlertAction.actionWithTitle("Cancel", style: UIAlertActionStyleDestructive, handler: lambda { |result| stopSpinner})
			acceptAction = UIAlertAction.actionWithTitle("Yes, Delete", style: UIAlertActionStyleDefault, handler: lambda {|reuslt| APIRequest.new.get("cte", {carton: @carton_delete.text, site:  UIApplication.sharedApplication.delegate.site, user: UIApplication.sharedApplication.delegate.username.downcase})  do |result| 
													stopSpinner
													if result["success"] 
														@carton_delete.text = ""
														@builder.updateAlertArea
													else
														App.alert(result["result"])
													end
												end
											})
			alert.addAction(cancelAction)
			alert.addAction(acceptAction)
			self.presentViewController(alert, animated: true, completion: nil)
		elsif @header.text.downcase.match(/^skd/) != nil
			if @cartons.empty?
				stopSpinner
				App.alert "You have no cartons selected."
			else
				APIRequest.new.get('skid_create', {user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, skid: @skid_num.text, cartons: @cartons.join(',')}) do |result|
					skid_num = nil
					unless @skid_num.text.empty?
						skid_num = @skid_num.text
					end
					if result["success"]
						skid_num = skid_num.nil? ? result["result"]["Status"].strip : skid_num
						APIRequest.new.get('skid_label', {user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, skid_num: skid_num, printer: UIApplication.sharedApplication.delegate.printer}) do |result|
							if result["success"]
								clearSubViews
								@skid_num.text = ""
								@so_num.text = ""
								@builder.buildSKD1(self, nil)
								@builder.updateAlertArea
								stopSpinner
							else
								stopSpinner
								App.alert("#{result["result"]}")
							end
						end
					else
						stopSpinner
						App.alert("#{result["result"]["error"]}")
					end
				end
			end
		elsif @header.text.downcase.match(/^bkf/) != nil
			if @qty.text.to_i == 0
				stopSpinner
				App.alert "You must enter a quantity to process backflush."
			else
				APIRequest.new.get("bkf", {part: @item_num.text, qty: @qty.text, prod_line: @prod_line.text, user_initials: @user_initials.text, user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site.downcase}) do |result|
					stopSpinner
					if result["Status"]
						@item_num.text = ""
						@qty.text = ""
						@prod_line.text = ""
						@builder.updateAlertArea
					else
						@builder.updateAlertArea("failure", result[:error])
					end
				end
			end
		else
			if @new_tag_num.text.empty?
				if @header.text.downcase.match(/por/) != nil
					@data = nil
					self.view.subviews.each {|subview| subview.class == UIScrollView ? @data = subview : next}
					if @data.nil?
						stopSpinner
					else
						begin
							lines = [] 
							locations = []
							qtys = []
							multipliers = []

							@data.subviews.each do |subview|
								if subview.class == UIView
									line = subview.subviews[0].text.match(/\d+/)

									unless subview.subviews[2].text == "" || subview.subviews[3].text == ""
										if subview.subviews[3].text.to_i < 0
											stopSpinner
											return @builder.updateAlertArea('failure', "You cannot have a negative quantity.\n Please check the qtys you entered \n and Submit the transaction again.")
										else
											lines << line[0] unless line.nil?
											locations << subview.subviews[2].text
											qtys << subview.subviews[3].text
											multipliers << subview.subviews[4].text
										end
									end
								end
							end

							label_count = "1"
							APIRequest.new.get(@header.text, {type: "por", po_num: @po_number.text, locations: locations, qtys: qtys, multipliers: multipliers, lines: lines, label_count: "#{label_count}", user: UIApplication.sharedApplication.delegate.username.downcase, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site:  UIApplication.sharedApplication.delegate.site.downcase}) do |result|

								po_text = @po_number.text

								if result["success"]
									success_response = nil

									loopPORcheck(result)
									# AFMotion::JSON.get("http://qadnix.endura.enduraproducts.com/cgi-bin/testapi/xxapiporkey.p?key=#{result["unique_key"]}&userid=#{UIApplication.sharedApplication.delegate.username.downcase}") do |result|
									# 	p result
									# 	case result.object["Status"].downcase
									# 	when "wait"
									# 		p result
									# 		sleep 5
									# 	when "error"
									# 		self.navigationItem.rightBarButtonItem.enabled = true
									# 		@builder.updateAlertArea("failure", "#{result.object["Error"]}")
									# 		stopSpinner

									# 	else
									# 		p result.object
									# 		self.navigationItem.rightBarButtonItem.enabled = true

									# 		clearSubViews
									# 		@po_number.text = po_text
									# 		poValidate(@po_number.text)
									# 		po_text = nil

									# 		stopSpinner
									# 	end
									# end

									# p "http://qadnix.endura.enduraproducts.com/cgi-bin/testapi/xxapiporkey.p?key=#{result[:unique_key]}&userid=#{UIApplication.sharedApplication.delegate.username.downcase}"
									# @builder.updateAlertArea
								else
									self.navigationItem.rightBarButtonItem.enabled = true
									@builder.updateAlertArea("failure", "#{result[:error]}")
									stopSpinner
								end
							end
						rescue => error
							stopSpinner
							@builder.updateAlertArea("failure", error)
						end
					end
				else
					APIRequest.new.get('skid_label', {user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, skid_num: @skid_num.text, printer: UIApplication.sharedApplication.delegate.printer}) do |result|
						if result["success"]
							clearSubViews
							@skid_num.text = ""
							@builder.buildSkidLabel(self, nil)
							@builder.updateAlertArea
						else
							App.alert("#{result["result"]}")
						end
						stopSpinner
					end
				end
			else
				if @header.text.downcase.match(/plo/) && @to_loc.text.empty?
					App.alert 'You must have a to location.'
					stopSpinner
				else
					if @qty.text.to_i < 0
						App.alert('You cannot have a negative quantity.')
						stopSpinner
					else
				  	APIRequest.new.get('tag_details', {tag: @new_tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				  		item = validate_text_presence(@item_num.text, result["result"]["ttitem"])
				  		from_loc = validate_text_presence(@from_loc.text, result["result"]["ttloc"])
				  		to_loc = validate_text_presence(@to_loc.text, result["result"]["ttloc"])
				  		to_site = validate_text_presence(@to_site.text, result["result"]["ttsite"])
				  		from_site = validate_text_presence(@from_site.text, result["result"]["ttsite"])
				  		if (@header.text.downcase.include?("pul") || @header.text.downcase.include?("pct")) && @qty.text.empty?
				  			App.alert("Must enter a qty")
				  			self.navigationItem.rightBarButtonItem.enabled = true
				  			stopSpinner
				  			break
				  		else
				  			qty = validate_text_presence(@qty.text, result["result"]["ttqtyloc"])
				  		end
				  		if result["success"] == true 
				  			result = result["result"]
	  	
				  			APIRequest.new.get(@header.text, {item_num: item, qty_to_move: qty, from_loc: from_loc, to_loc: to_loc, tag: @new_tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: from_site, to_site: to_site, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
				  				if result["success"] == true
				  					tag_num = @new_tag_num.text 
				  					@builder.updateAlertArea
	
				  					if @header.text.downcase.match(/pct/) != nil || @header.text.downcase.match(/plo/) != nil
				  						alert = UIAlertController.alertControllerWithTitle("Would you like to print a new label?", message:  "",preferredStyle: UIAlertControllerStyleAlert)
				  						cancelAction = UIAlertAction.actionWithTitle("No Thanks", style: UIAlertActionStyleDestructive, handler: lambda { |result| 
				  																																																															functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
				  																																																														})
				  						printAction = UIAlertAction.actionWithTitle("Yes, Please", style: UIAlertActionStyleDefault, handler: lambda {|reuslt| APIRequest.new.get("print_label", {tag: tag_num, printer:  UIApplication.sharedApplication.delegate.printer.downcase, user_id: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, trans_type: "#{@header.text.downcase}", type: "print_label"}) {|result| functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)}})
				  						alert.addAction(cancelAction)
				  						alert.addAction(printAction)
				  						self.presentViewController(alert, animated: true, completion: nil)
				  					else
				  						functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
				  					end
				  				else
				  					@builder.updateAlertArea("failure", result["result"])
				  				end
				  				stopSpinner
				  			end	
				  		else
				  			if @header.text.downcase.match(/plo/).nil?
				  				stopSpinner
				  			else
				  				APIRequest.new.get(@header.text, {item_num: item, qty_to_move: qty, from_loc: from_loc, to_loc: to_loc, tag: @new_tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: from_site, to_site: to_site, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
				  					if result["success"] == true 
				  						tag_num = @new_tag_num.text 
				  						@builder.updateAlertArea
 	
				  						if @header.text.downcase.match(/pct/) != nil || @header.text.downcase.match(/plo/) != nil
				  							alert = UIAlertController.alertControllerWithTitle("Would you like to print a new label?", message:  "",preferredStyle: UIAlertControllerStyleAlert)
				  							cancelAction = UIAlertAction.actionWithTitle("No Thanks", style: UIAlertActionStyleDestructive, handler: lambda { |result| functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)})
				  							printAction = UIAlertAction.actionWithTitle("Yes, Please", style: UIAlertActionStyleDefault, handler: lambda {|reuslt| APIRequest.new.get("print_label", {tag: tag_num, printer:  UIApplication.sharedApplication.delegate.printer.downcase, user_id: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, trans_type: "#{@header.text.downcase}", type: "print_label"}) {|result| functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)}})
				  							alert.addAction(cancelAction)
				  							alert.addAction(printAction)
				  							self.presentViewController(alert, animated: true, completion: nil)
				  						else
				  							functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
				  						end
				  					else
				  						@builder.updateAlertArea("failure", result["result"])
				  					end
				  					stopSpinner
				  				end	
				  			end
				  		end
				  	end
				  end
				end
			end
		end
	end

	def next
		title = @header.text.downcase

		if !title.match(/vmi/).nil?
			if UIApplication.sharedApplication.delegate.vmi_complete
				APIRequest.new.post('submit_vmi_tag', {distribution_num: @distribution_num.text,
																							 user: UIApplication.sharedApplication.delegate.username.downcase,
																							 action: 'pick',
																							 tags: @builder.scanned_tags.join(',')}) do |result|
					if result[:success] == "Good"
						App.alert("Order successfully placed.")
					else
						App.alert("Error! #{result[:error]}")
					end
					UIApplication.sharedApplication.delegate.vmi_complete = nil
					@builder.tag_view_area.subviews.each { |subview| subview.removeFromSuperview }
					@builder.header_area.subviews.each { |subview| subview.removeFromSuperview }

					@distribution_num.text = ''
					@distribution_num.becomeFirstResponder	
					@builder.header_area.backgroundColor = UIColor.whiteColor
					@builder.scanned_tags = []
				end
			else
				APIRequest.new.get('vmi_details', {distribution_num: @distribution_num.text, user: UIApplication.sharedApplication.delegate.username.downcase, action: 'get'}) do |result|
					if result[:success] == "Good"
						@builder.buildVMI(self, result["INFO"], result["Weight"], result["Customer"], result["FBM"])
					else
						App.alert("Error! #{result[:error]}")
					end
				end
			end
		else
			self.navigationItem.rightBarButtonItem.enabled = true
			tag = !title.match(/plo/).nil? ? @new_tag_num.text : @tag_num.text
			current_text = !title.match(/plo/).nil? ? @new_tag_num.text : @tag_num.text
			APIRequest.new.get('tag_details', {tag: tag, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				if  @header.text.match(/^\w+\s+/)[0].strip == "POR" || @header.text.match(/^\w+\s+/)[0].strip == "PICK" || @header.text.match(/^\w+\s+/)[0].strip == "CAR" || @header.text.match(/^\w+\s+/)[0].strip == "SKD"
				temp = self.view.frame
				temp.origin.x = -1000
				UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationCurveEaseOut, animations: lambda { @tag_num.frame = temp}, completion: lambda {
					|finished| 
					header_txt = @header.text.match(/^\w+\s+/)[0].strip
					clearSubViews unless header_txt == "CAR"
		
					@tag_num.userInteractionEnabled = false
		
					case header_txt
					when "POR"
						poValidate(@po_number.text)
					when "CAR"
						line_number = @line_number.class == String ? @line_number : @line_number.text
						if line_number.empty?
							App.alert "You must enter a line number."
							@line_number.becomeFirstResponder unless @line_number.class == String
						else
							clearSubViews
							@builder.buildCAR2(self, current_text)
						end
					when "SKD"
						@builder.buildSKD2(self, current_text)
					when "PICK"
						@builder.buildSHP2(self, current_text)
					else
						@builder.buildGenericView(self, current_text)
					end
				})
				elsif result["result"]["ttsite"] == UIApplication.sharedApplication.delegate.site || (@header.text.match(/^\w+\s+/)[0].strip == "PLO" && result["result"]["ttsite"].empty?)
					temp = self.view.frame
					temp.origin.x = -1000
					UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationCurveEaseOut, animations: lambda { @tag_num.frame = temp}, completion: lambda {
						|finished| 
						header_txt = @header.text.match(/^\w+\s+/)[0].strip
						clearSubViews unless header_txt == "CAR"
			
						@tag_num.userInteractionEnabled = false
			
						case header_txt
						when "PDL"
							@builder.buildPDL(self, current_text)
						when "PUL"
							@builder.buildPUL(self, current_text)
						when "PMV"
							@builder.buildPMV(self, current_text)
						when "PCT"
							@builder.buildPCT(self, current_text)
						when "PLO"
							@builder.buildPLO(self, current_text)
						when "Skid"#"Skid Label"
							@builder.buildSkidLabel(self, current_text)
						when "TPT"
							@builder.buildTPT(self, current_text)
						when "GLB"
							@builder.buildGLB(self, current_text)
						else
							@builder.buildGenericView(self, current_text)
						end
					})
				else
					App.alert("You cannot access site data from a different site.")
				end
			end
		end
	end

	def functionStartingPoint(header)
		begin
			clearSubViews do 
				case header

				when "GLB"
					@builder.buildGLB(self, nil)
				when "TPT"
					@builder.buildTPT(self, nil)
				when "Skid"
					@builder.buildSkidLabel(self, nil)
				when "POR"
					@builder.buildPOR1(self, nil)
				when "SKD"
					@builder.buildSKD1(self, nil)
				when "CAR"
					@builder.buildCAR1(self, nil)
				when "PICK"
					@builder.buildSHP1(self, nil)
				when "BKF"
					@builder.buildBKF(self, nil)
			  else
					@builder.buildStartingPoint(self)
				end
			end
		rescue
		end
	end

	def new_pallet
		@builder.clearTextFields
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		APIRequest.new.get('plo_next_pallet', {}) do |result|
			@new_tag_num.text = result["result"]
			@builder.new_pallet = true
			@item_num.becomeFirstResponder
			#stopSpinner
		end
	end

	def settings
		unless @builder.nil?
			@builder.clearTextFields
		end
	end

	def validate_text_presence(text, returned_value)
		text.empty? ? returned_value : text
	end

	def showSpinner
		self.navigationItem.rightBarButtonItem.enabled = false unless self.navigationItem.rightBarButtonItem.nil?
		@spinner = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
		@spinner.color = UIColor.blueColor
		@spinner.frame = [[self.view.frame.size.width / 2,self.view.frame.size.height / 3],[100,100]]
		@spinner.color = UIColor.blueColor
		@spinner.startAnimating
		self.view.addSubview(@spinner)
	end

	def delayShowSpinner
		self.navigationItem.rightBarButtonItem.enabled = false unless self.navigationItem.rightBarButtonItem.nil?
		@spinner = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
		@spinner.color = UIColor.blueColor
		@spinner.frame = [[self.view.frame.size.width / 2,self.view.frame.size.height / 3],[100,100]]
		@spinner.color = UIColor.blueColor
		self.performSelector("stopSpinner", withObject:nil, afterDelay:12.0)
		@spinner.startAnimating
		self.view.addSubview(@spinner)
	end


	def stopSpinner
		self.view.subviews.each do |view|
			if view.class == UIActivityIndicatorView
				view.stopAnimating
				view.removeFromSuperview
			end
		end
	end

	def clearSubViews(&block)
		self.navigationItem.rightBarButtonItem = nil
		self.view.subviews.each do |subview|
			subview.removeFromSuperview
		end
		block.call unless block.nil?
	end

	def poValidate(po_number)
		@locations_by_item = Hash.new
		@locations = Array.new

		showSpinner
		APIRequest.new.get("po_details", {po_number: @po_number.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, type: "po_details"}) do |result|
		  stopSpinner
		  if result["success"] 
		  	result["result"]["Loclist"].each do |locs|
		  		@locations << locs["ttloclist"]
		  	end

		  	result["result"]["Locs"].each do |locs|
		  		if @locations_by_item[locs["ttpart"]].nil?
		  			@locations_by_item[locs["ttpart"]] = [locs["ttlocs"]]
		  		else
		  			@locations_by_item[locs["ttpart"]] << locs["ttlocs"]
		  		end
		  	end

		  	
		  	@po_items = result["result"]["Lines"]
		  	@po_items_count = result["result"]["Lines"].count
		  	@builder.buildPOR2(self, {po_items: @po_items, items_count: @po_items_count, locations: @locations, default_locations: @locations_by_item, po_number: po_number})
			else
				@builder.buildPOR1(self, nil)
				@builder.updateAlertArea("failure", result["result"])
			end
		end
	end

	def closePopup
		@popup.removeFromSuperview
		@popup = nil
	end

	def loopPORcheck(result)
		original_request =  result
		po_text = @po_number.text

		AFMotion::JSON.get("http://#{@qad_env}.endura.enduraproducts.com/cgi-bin/#{@qad_api}/xxapiporkey.p?key=#{result["unique_key"]}&userid=#{UIApplication.sharedApplication.delegate.username.downcase}") do |result|
			if result.success?
		    case result.object["Status"].downcase
				when "wait" 
					sleep 5
				when "error"
					self.navigationItem.rightBarButtonItem.enabled = true
					@builder.updateAlertArea("failure", "#{result.object["Error"]}")
					stopSpinner
					break
				else
					self.navigationItem.rightBarButtonItem.enabled = true

					clearSubViews
					@po_number.text = po_text
					poValidate(@po_number.text)
					@builder.updateAlertArea
					po_text = nil

					stopSpinner
					break
				end
				loopPORcheck(original_request)
		  elsif result.failure?
		  	App.alert("There was a failure on the API request")
		  	stopSpinner
		  	break
			end
		end
	end
	
	#Delegate Methods
	def numberOfSectionsInTableView(tableView)
		if tableView == @table
			@headers.count
		else
			@po_items_count
		end
	end

	def tableView(tableView, titleForHeaderInSection: section)
		if tableView == @table
			@headers.keys.objectAtIndex(section)
		end
	end


	def tableView(tableView, willDisplayHeaderView: view, forSection: section)
		view.tintColor = UIColor.colorWithRed(0.63, green: 0.52, blue: 0.31, alpha: 1.0)
		view.textLabel.textColor = UIColor.whiteColor
		view.textLabel.font = UIFont.fontWithName("Baskerville-SemiBold", size: 15.0)
		view.textLabel.textAlignment = NSTextAlignmentCenter
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
			UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @reuseIdentifier)
		end
 		
 		if tableView == @table
			cell.textLabel.text = @headers.values[indexPath.section][indexPath.row]
			cell.textLabel.font = UIFont.fontWithName("ZapfDingbatsITC", size: 15.0) 
			cell.setSelectedBackgroundView(@cell_bg)
		else
			unless @po_items[indexPath.row].nil?
				qty = UILabel.new
		    qty.text = "Open Qty: #{@po_items[indexPath.row]["ttqtyopen"]}"
		    qty.frame = [[cell.frame.size.width - 40, 0], [300, cell.frame.size.height]]	
		    qty.textAlignment = NSTextAlignmentRight	    
		    qty.adjustsFontSizeToFitWidth = true

				cell.textLabel.text = @po_items[indexPath.row]["ttitem"]
				cell.detailTextLabel.text = "Line # #{@po_items[indexPath.row]["ttline"]}"
		    cell.contentView.addSubview(qty)
			end
			# cell.textLabel.text = @po_items[indexPath.row]
		end
		cell
	end

	def tableView(tableView, numberOfRowsInSection: section)
		@headers.values[section].count
	end

	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		if tableView == @table
			@header.text = "#{@headers.values[indexPath.section][indexPath.row]}"

			clearSubViews
			@builder.clearAlertArea
			@builder.clearTextFields

			functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
		else
		end
	end

	def searchBarShouldBeginEditing(searchBar)
		if !@popup.nil?
			@popup.subviews.each { |subview| subview.removeFromSuperview }
			@popup.removeFromSuperview
			@popup = nil
		end
		p "START EDITING"
	end

	def searchBarSearchButtonClicked(searchBar)
		APIRequest.new.get('item_lookup', {part: searchBar.text, site: UIApplication.sharedApplication.delegate.site.to_s, user:UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			if result["success"] == "good"
				info = result["INFO"].last
				unless self.view.subviews.include?(@popup)
					@popup= UIScrollView.new
					@popup.frame = [[self.view.frame.size.width / 3.5,self.view.frame.size.height / 3.5],[self.view.frame.size.width / 2, self.view.frame.size.height/2]]
	    		@popup.setBackgroundColor(UIColor.blackColor)
	  			@popup.alpha=0.9

	  			close_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
	  			close_btn.tintColor = UIColor.blackColor
	  			close_btn.frame = [[0,0], [50,50]]
					close_btn.setTitle('x', forState:UIControlStateNormal)
					close_btn.setBackgroundColor(UIColor.redColor)
					close_btn.addTarget(self, action: 'closePopup', forControlEvents:UIControlEventTouchUpInside)
	  			@popup.addSubview(close_btn)
	  			
	  			header = UILabel.new
	  			header.frame = [[50,0],[@popup.frame.size.width- 50,50]]
	  			header.setBackgroundColor(UIColor.redColor)
	  			header.textAlignment = NSTextAlignmentCenter
	  			header.text = "#{searchBar.text}"
	  			@popup.addSubview(header)

	  			desc = UILabel.new
	  			desc.frame = [[0,50],[@popup.frame.size.width, 50]]
	  			desc.setBackgroundColor(UIColor.whiteColor)
	  			desc.textAlignment = NSTextAlignmentCenter
	  			#desc.text = "Item Description: #{info['ttdesc1']}"
	  			desc.text = "Item Description: #{info['ttdesc2']}"
	  			@popup.addSubview(desc)

	  			position = 60
	  			result["INFO"].each do |info|
	  				unless info['ttqtyloc'].to_i < 0
	  					position = position += 60
		  				loc = UILabel.new
		  				loc.frame = [[10,position],[@popup.frame.size.width / 4, 50]]
		  				loc.color = UIColor.whiteColor
		  				loc.adjustsFontSizeToFitWidth = true
		  				loc.text = "Location: #{info['ttloc']}"
		
		  				qty_label = UILabel.new
		  				qty_label.frame = [[(@popup.frame.size.width / 4) + 15, position], [@popup.frame.size.width / 4, 50]]
		  				qty_label.color = UIColor.whiteColor
		  				qty_label.adjustsFontSizeToFitWidth = true
		  				qty_label.text = "Qty: #{info['ttqtyloc'].to_i}"
		
		  				tag = UILabel.new
		  				tag.frame = [[(@popup.frame.size.width / 4) + 105 , position], [(@popup.frame.size.width / 4), 50]]
		  				tag.color = UIColor.whiteColor
		  				tag.adjustsFontSizeToFitWidth = true
		  				tag.text = "Tag: #{info['tttag']}"
		
		  				status = UILabel.new
		  				status.frame = [[(@popup.frame.size.width / 4) + 245 , position], [(@popup.frame.size.width / 4), 50]]
		  				status.color = UIColor.whiteColor
		  				status.adjustsFontSizeToFitWidth = true
		  				status.text = "Status: #{info['ttstatus']}"
		  				
		  				@popup.addSubview(loc)
		  				@popup.addSubview(qty_label)
		  				@popup.addSubview(tag)
		  				@popup.addSubview(status)
		
		  				loc = nil
		  				qty_label = nil
		  				tag = nil
		  				status = nil
		  			end
		  		end

	  			@popup.contentSize = CGSizeMake(@popup.frame.size.width - 440, position+50)

	  			self.view.addSubview(@popup)
	  			searchBar.text = ""
	  			searchBar.resignFirstResponder
	  		end

  			header = nil
  			desc = nil
		  else
		  	App.alert("Item not found")
		  end
		end
	end
end