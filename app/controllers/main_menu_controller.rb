class MainMenuController < UIViewController

	def viewDidLoad
		self.title = 'Main Menu'
		self.view.backgroundColor = UIColor.whiteColor
		self.automaticallyAdjustsScrollViewInsets = false

		search = UISearchBar.new
		search.delegate = self
		search.frame = [[self.view.frame.size.width - 250,-10],[200,50]]
		self.navigationController.navigationBar.addSubview(search)

		img = nil
		button = nil
		@po_items_count = 0

		#@headers = {"Inventory" => ["PCT (Pallet Cycle Count)", "PDL (Pallet Delete)", "PLO (Pallet Load)", "PMV (Pallet Move)", "PUL (Pallet Unload)"], "Receiving" => ["POR (Purchase Order Receipt)"], "Labels" => ["TPT (Tag Reprint)", "GLB (General Label)", "Skid label"], "Shipping" => ["CAR (Carton Create)", "CTE (Carton Edit)", "SKD (Skid Create)", "SKE (Skid Edit)", "SHP (Shipping)"]}
		@headers = {"Inventory" => ["PCT (Pallet Cycle Count)", "PDL (Pallet Delete)", "PLO (Pallet Load)", "PMV (Pallet Move)", "PUL (Pallet Unload)"], "Receiving" => ["POR (Purchase Order Receipt)"], "Labels" => ["TPT (Tag Reprint)", "GLB (General Label)", "Skid label"]}
		@to_locations = ["","2110", "2400", "SAMPLE"]

		#Sets initial Screen View and also gets initial accessor values from ScreenBuilder Model
		@builder = ScreenBuilder.alloc.initWithView(self)
		@builder.initUIPickerView(self)
		@builder.buildMainMenu(self)
		@cell_bg = @builder.cell_bg
		@item_num = @builder.item_num
		@from_loc = @builder.from_loc
		@tag_num = @builder.tag_num
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
		@label_count = @builder.label_count
		@po_items = nil
		super

	end

	def submit
		@builder.clearAlertArea
		self.view.endEditing(true)
		showSpinner
		if @header.text.downcase.match(/glb/) != nil
			APIRequest.new.get("glb", {remarks: @remarks.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, printer:  UIApplication.sharedApplication.delegate.printer.downcase, type: "#{@header.text.downcase}"}) do |result|
				@builder.updateAlertArea
				stopSpinner
			end
		else
			if @tag_num.text.empty?
				if @header.text.downcase.match(/por/) != nil
					@data = nil
					self.view.subviews.each {|subview| subview.class == UIScrollView ? @data = subview : next}
					if @data.nil?
						stopSpinner
					else
						begin
							tag_nums = [] 
							@data.subviews.each do |subview|
								if subview.class == UIView
									line = subview.subviews[2].text.match(/\d+/)
									line = line[0] unless line.nil?
									APIRequest.new.get(@header.text, {type: "por", po_num: @po_number.text, location: subview.subviews[4].text, qty: subview.subviews[1].text, line: line, label_count: "#{@label_count.text}", user: UIApplication.sharedApplication.delegate.username.downcase, printer:  UIApplication.sharedApplication.delegate.printer.downcase}) do |result|
										tag_nums << result["Tag"]
										stopSpinner
									end if subview.subviews[1].text.to_i > 0
								else
									stopSpinner
								end

							end

							tag_nums.each do |tag_num|
								unless tag_num.empty?
									APIRequest.new.get("print_label", {tag: tag_num, printer:  UIApplication.sharedApplication.delegate.printer.downcase, user_id: UIApplication.sharedApplication.delegate.username.downcase, type: "print_label"}) do |result|
									end
								end
							end
						rescue => error
							error
						end
					end
					@po_number.text = ""
					clearSubViews
					@builder.buildPOR1(self, nil)
				end
			else
				APIRequest.new.get('tag_details', {tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
					item = validate_text_presence(@item_num.text, result["result"]["ttitem"])
					from_loc = validate_text_presence(@from_loc.text, result["result"]["ttloc"])
					to_loc = validate_text_presence(@to_loc.text, result["result"]["ttloc"])
					to_site = validate_text_presence(@to_site.text, result["result"]["ttsite"])
					from_site = validate_text_presence(@from_site.text, result["result"]["ttsite"])
					qty = validate_text_presence(@qty.text, result["result"]["ttqtyloc"])
					if result["success"] == true 
						result = result["result"]
	
						APIRequest.new.get(@header.text, {item_num: item, qty_to_move: qty, from_loc: from_loc, to_loc: to_loc, tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: from_site, to_site: to_site, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
							if result["success"] == true 
								@builder.updateAlertArea
								functionStartingPoint(@header.text.match(/^\w+\s+/)[0].strip)
								unless @header.text.downcase.match(/pct/).nil? && @header.text.downcase.match(/plo/).nil?
									alert = UIAlertController.alertControllerWithTitle("Would you like to print a new label?", message:  "",preferredStyle: UIAlertControllerStyleAlert)
									cancelAction = UIAlertAction.actionWithTitle("No Thanks", style: UIAlertActionStyleDestructive, handler: lambda { |result| })
									printAction = UIAlertAction.actionWithTitle("Yes, Please", style: UIAlertActionStyleDefault, handler: lambda {|reuslt| APIRequest.new.get("print_label", {tag: @tag_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, user_id: UIApplication.sharedApplication.delegate.username.downcase, type: "print_label"}) {|result|}})
									alert.addAction(cancelAction)
									alert.addAction(printAction)
									self.presentViewController(alert, animated: true, completion: nil)
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
							APIRequest.new.get(@header.text, {item_num: item, qty_to_move: qty, from_loc: from_loc, to_loc: to_loc, tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: from_site, to_site: to_site, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
								if result["success"] == true 
									@builder.updateAlertArea
									
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

	def next
		current_text = @tag_num.text
		temp = self.view.frame
		temp.origin.x = -1000
		UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationCurveEaseOut, animations: lambda { @tag_num.frame = temp}, completion: lambda {
			|finished| 
			clearSubViews

			@tag_num.userInteractionEnabled = false

			case @header.text.match(/^\w+\s+/)[0].strip
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
			when "POR"
				poValidate(@po_number.text)
			else
				@builder.buildGenericView(self, current_text)
			end
		})
	end

	def functionStartingPoint(header)
		clearSubViews
		case header

		when "GLB"
			@builder.buildGLB(self, nil)
		when "TPT"
			@builder.buildTPT(self, nil)
		when "Skid"
			@builder.buildSkidLabel(self, nil)
		when "POR"
			@builder.buildPOR1(self, nil)
	  else
			@builder.buildStartingPoint(self)
		end
	end

	def new_pallet
		@builder.clearTextFields
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		APIRequest.new.get('plo_next_pallet', {}) do |result|
			@tag_num.text = result["result"]
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
		@spinner = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
		@spinner.color = UIColor.blueColor
		@spinner.frame = [[self.view.frame.size.width / 2,self.view.frame.size.height / 3],[100,100]]
		@spinner.color = UIColor.blueColor
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

	def clearSubViews
		self.view.subviews.each do |subview|
			subview.removeFromSuperview
		end
	end

	def poValidate(po_number)
		APIRequest.new.get("po_details", {po_number: @po_number.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, type: "po_details"}) do |result|
		  if result["success"] 
		  	@po_items = result["result"]["Lines"]
		  	@po_items_count = result["result"]["Lines"].count
		  	@builder.buildPOR2(self, {po_items: @po_items, items_count: @po_items_count, locations: result["result"]["Locs"]})
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

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
			UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: @reuseIdentifier)
		end
 		
 		if tableView == @table
			cell.textLabel.text = @headers.values[indexPath.section][indexPath.row]
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

	def pickerView(pickerView, numberOfRowsInComponent: componenent)
		@to_locations.count
	end

	def pickerView(pickerView, titleForRow: row, forComponent: componenent)
		@to_locations[row]
	end

	def numberOfComponentsInPickerView(pickerView)
		1
	end

	def pickerView(pickerView, didSelectRow: row, inComponent: componenent)
		@to_loc.text = "#{@to_locations[row]}"
		@to_loc.resignFirstResponder	
	end

	def searchBarSearchButtonClicked(searchBar)
		AFMotion::JSON.get("http://qadnix.endura.enduraproducts.com/cgi-bin/devapi/xxapigetlocs.p", {part: searchBar.text, site: UIApplication.sharedApplication.delegate.site.to_s, user:UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			if result.success?
				result = BW::JSON.parse(result.body)
				if result["success"] == "good"
					info = result["INFO"].last
					@popup= UIView.new
					@popup.frame = [[self.view.frame.size.width / 3.5,self.view.frame.size.height / 3.5],[self.view.frame.size.width / 2, self.view.frame.size.height/2]]
	    		@popup.setBackgroundColor(UIColor.blackColor)
	  			@popup.alpha=0.6

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
	  			desc.frame = [[20,60],[@popup.frame.size.width, 50]]
	  			desc.color = UIColor.whiteColor
	  			desc.text = "Item Description: #{info['ttdesc2']}"
	  			@popup.addSubview(desc)

	  			loc = UILabel.new
	  			loc.frame = [[20,120],[@popup.frame.size.width, 50]]
	  			loc.color = UIColor.whiteColor
	  			loc.text = "Item Location: #{info['ttloc']}"
	  			@popup.addSubview(loc)

	  			self.view.addSubview(@popup)

	  			header = nil
	  			desc = nil
	  			loc = nil
	  		else
	  			App.alert("Item not found")
	  		end
		  elsif result.failure? 
		  	p result.error.localizedDescription
		    #block.call({success: false, error: result.error.localizedDescription})
		  end
		end
	end
end