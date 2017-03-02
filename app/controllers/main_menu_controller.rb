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
		# self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('settings_image.png'), style: UIBarButtonItemStylePlain, target: self, action: nil)
		@headers = {"Transactions" => ["PCT", "PDL", "PLO", "PMV", "PUL"], "Label Printing" =>["Skid Label"]}
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

		APIRequest.new.get(@header.text, {item_num: @item_num.text, qty_to_move: @qty.text, from_loc: @from_loc.text, to_loc: @to_loc.text, tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase, from_site: @from_site.text, to_site: @to_site.text, skid_num: @skid_num.text, printer:  UIApplication.sharedApplication.delegate.printer.downcase, site: UIApplication.sharedApplication.delegate.site.downcase, lot: @lot.text, remarks: @remarks.text, type: "#{@header.text.downcase}"}) do |result|
			if result["success"] == true 
				@builder.updateAlertArea
			else
				@builder.updateAlertArea("failure", result["result"])
			end
		end		
	end

	def settings
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

		case @header.text
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
		when "Skid Label"
			@builder.buildSkidLabel(self)
		else
			@builder.buildPUL(self)
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