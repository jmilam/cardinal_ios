class MainMenuController < UIViewController

	def viewDidLoad
		self.title = 'Main Menu'
		self.view.backgroundColor = UIColor.whiteColor
		img = UIImage.imageNamed('settings_image.png')
		button = UIButton.buttonWithType(UIButtonTypeCustom)
		button.bounds = [[0,0],[img.size.width, img.size.height]]
		button.setImage(img, forState:UIControlStateNormal)
		button.addTarget(self, action: settings, forControlEvents: UIControlEventTouchUpInside)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(button)
		img = nil
		button = nil

		@headers = {"Inventory" => ["PCT (Pallet Cycle Count)", "PDL (Pallet Delete)", "PLO (Pallet Load)", "PMV (Pallet Move)", "PUL (Pallet Unload)"], "Receiving" => ["POR (Purchase Order Receipt)"], "Labels" => ["TPT (Tag Reprint)", "GLB (General Label)", "Skid label"], "Shipping" => ["CAR (Carton Create)", "CTE (Carton Edit)", "SKD (Skid Create)", "SKE (Skid Edit)", "SHP (Shipping)"]}
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

		super

	end

	def submit
		@builder.clearAlertArea
		showSpinner
		APIRequest.new.get('tag_details', {tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			item = validate_text_presence(@item_num.text, result["ttitem"])
			from_loc = validate_text_presence(@from_loc.text, result["ttloc"])
			to_loc = validate_text_presence(@to_loc.text, result["ttloc"])
			to_site = validate_text_presence(@to_site.text, result["ttsite"])
			from_site = validate_text_presence(@from_site.text, result["ttsite"])
			qty = validate_text_presence(@qty.text, result["ttqtyloc"])

			if result["success"] == true 
				result = result["result"]

				APIRequest.new.get(@header.text, {item_num: item, qty_to_move: qty, from_loc: from_loc, to_loc: to_loc, tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: from_site, to_site: to_site, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
					if result["success"] == true 
						@builder.updateAlertArea
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

	def new_pallet
		APIRequest.new.get('plo_next_pallet', {}) do |result|
			@tag_num.text = result["result"]
			@builder.new_pallet = true
			@item_num.becomeFirstResponder
			stopSpinner
		end
	end

	def settings
	end

	def validate_text_presence(text, returned_value)
		text.empty? ? returned_value : text
	end

	def showSpinner
		@spinner = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
		@spinner.color = UIColor.blueColor
		@spinner.frame = [[self.view.frame.size.width / 2,self.view.frame.size.height / 3],[100,100]]
		# @spinner = UIActivityIndicatorView.alloc.initWithFrame([[self.view.frame.size.width / 2,self.view.frame.size.height / 3],[100,100]])
		@spinner.color = UIColor.blueColor
		@spinner.startAnimating
		self.view.addSubview(@spinner)
	end

	def stopSpinner
		@spinner.stopAnimating
		@spinner.removeFromSuperview
	end

	#Delegate Methods
	def numberOfSectionsInTableView(tableView)
		@headers.count
	end

	def tableView(tableView, titleForHeaderInSection: section)
		@headers.keys.objectAtIndex(section)
	end

	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "CELL_IDENTIFIER"

		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
			UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)
		end
 
		cell.textLabel.text = @headers.values[indexPath.section][indexPath.row]
		cell.setSelectedBackgroundView(@cell_bg)
		cell
	end

	def tableView(tableView, numberOfRowsInSection: section)
		@headers.values[section].count
	end

	def tableView(tableView, didSelectRowAtIndexPath: indexPath)
		@header.text = "#{@headers.values[indexPath.section][indexPath.row]}"

		self.view.subviews.each do |subview|
			subview.removeFromSuperview
		end
		@builder.clearAlertArea
		@builder.clearTextFields

		case @header.text.match(/^\w+\s+/)[0].strip
		when "PDL"
			@builder.buildPDL(self)
		when "PUL"
			@builder.buildPUL(self)
		when "PMV"
			@builder.buildPMV(self)
		when "PCT"
			@builder.buildPCT(self)
		when "PLO"
			@builder.buildPLO(self)
		when "Skid"#"Skid Label"
			@builder.buildSkidLabel(self)
		else
			@builder.buildGenericView(self)
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
end