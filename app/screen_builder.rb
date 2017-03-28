class ScreenBuilder < UIViewController

	attr_reader :table
	attr_reader :cell_bg
	attr_reader :item_num
	attr_reader :tag_num
	attr_reader :qty
	attr_reader :from_loc
	attr_reader :username
	attr_reader :to_loc
	attr_reader :header
	attr_reader :printer
	attr_reader :site_num
	attr_reader :to_site
	attr_reader :from_site
	attr_reader :password
	attr_reader :skid_num
	attr_reader :lot
	attr_reader :remarks
	attr_accessor :new_pallet

	def initWithView(view)
		@new_pallet = false
		createTable(view)
		@nav_bar_height = view.navigationController.navigationBar.frame.origin.y + view.navigationController.navigationBar.frame.size.height
		self
	end

	def buildLogIn(viewController)
		@username = createTextField
		addSharedAttributes(@username, 'Username')
		@username.becomeFirstResponder

		@password = createTextField
		addSharedAttributes(@password, 'Password')
		@password.secureTextEntry = true

		@site_num = createTextField
		addSharedAttributes(@site_num, 'Site Num', true)

		@printer = createTextField
		addSharedAttributes(@printer, 'Printer', true)

		@login = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@login.setTitle('Login', forState:UIControlStateNormal)
		@login.setTitle('Logging In..', forState:UIControlStateSelected)
		@login.addTarget(viewController, action: 'login', forControlEvents:UIControlEventTouchUpInside)


		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "username" => @username, "password" => @password, "site_num" => @site_num, "printer" => @printer, "login" => @login
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-75-[username(==height)]-margin-[password(==height)]-margin-[site_num(==height)]-margin-[printer(==height)]-margin-[login(==height)]-(>=15)-|"
			layout.horizontal "|-10-[username]-10-|"
			layout.horizontal "|-10-[password]-10-|"
			layout.horizontal "|-10-[site_num]-10-|"
			layout.horizontal "|-10-[printer]-10-|"
			layout.horizontal "|-10-[login]-10-|"
		end
	end

	def buildMainMenu(viewController)
		@alert_area = createView
		buildAlertArea(@alert_area)

		@header = createLabel
		@header.backgroundColor = UIColor.colorWithRed(0.84, green:0.26, blue: 0.21, alpha: 0.8)
		@header.textColor = UIColor.whiteColor
		@header.text = "Select Menu Function..."
		@header.textAlignment = UITextAlignmentCenter

		@item_num = createTextField
		@item_num.userInteractionEnabled = false
		addSharedAttributes(@item_num, 'Item Number - Informational Only')
		@item_num.delegate = self

		@tag_num = createTextField
		addSharedAttributes(@tag_num, 'Tag Number')
		@tag_num.delegate = self

		@qty = createTextField
		addSharedAttributes(@qty, 'Move Qty')

		@from_loc = createTextField
		addSharedAttributes(@from_loc, 'From Location')

		@to_loc = createTextField
		addSharedAttributes(@to_loc, 'To Location')

		@from_site = createTextField
		addSharedAttributes(@from_site, 'From Site')

		@to_site = createTextField
		addSharedAttributes(@to_site, 'To Site')

		@lot =createTextField
		addSharedAttributes(@lot, 'Lot')

		@remarks = createTextField
		addSharedAttributes(@remarks, 'Enter PCT Remarks...')

		@skid_num = createTextField
		addSharedAttributes(@skid_num, 'Skid Number')

		@current_qty = createLabel
		@current_qty.textAlignment = UITextAlignmentCenter
		@current_item = createLabel
		@current_item.textAlignment = UITextAlignmentCenter
		@current_item.numberOfLines = 2
		


		@cell_bg = createView
		@cell_bg.backgroundColor = UIColor.colorWithRed(0.48, green: 0.70, blue: 0.56, alpha: 0.8)

		@submit = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@submit.backgroundColor = UIColor.colorWithRed(0.63, green: 0.52, blue: 0.31, alpha: 1.0)
		@submit.tintColor = UIColor.whiteColor
		@submit.setTitle('Submit', forState:UIControlStateNormal)
		@submit.setTitle('Submiting...', forState:UIControlStateSelected)
		@submit.addTarget(viewController, action: 'submit', forControlEvents:UIControlEventTouchUpInside)

		@new_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@new_button.setTitle('New Pallet', forState: UIControlStateNormal)
		@new_button.addTarget(viewController, action: 'new_pallet', forControlEvents:UIControlEventTouchUpInside)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-10-|"
			sharedLayoutParameters(layout)
		end
		viewController
	end

	def buildPCT(viewController)
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "qty" => @qty, "current_qty" => @current_qty, "current_item" => @current_item, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20

			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num(==height)][qty(==height)]-margin-[current_item(==height)][current_qty(==height)]-margin-[submit(==height)]-(>=10)-|"

			
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
			
		end

		viewController
	end

	def buildPDL(viewController)
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "current_qty" => @current_qty, "current_item" => @current_item, "from_loc" => @from_loc, "to_loc" => @to_loc, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][item_num(==height)]-margin-[from_loc(==height)][to_loc(==height)]-margin-[current_item(==height)][current_qty(==height)]-margin-[submit(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildPLO(viewController)
		@tag_num.becomeFirstResponder
		@qty.placeholder = "Qty"
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		enableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "current_qty" => @current_qty, "current_item" => @current_item, "qty" => @qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "from_site" => @from_site, "to_site" => @to_site, "submit" => @submit, "new_button" => @new_button, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num(==height)][new_button(==height)]-margin-[item_num(==height)][qty(==height)]-margin-[from_site(==height)][to_site(==height)]-margin-[from_loc(==height)][to_loc(==height)]-margin-[current_item(==height)][current_qty(==height)]-margin-[submit(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[new_button(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[item_num(==half_width)]-[qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_site(==half_width)]-[to_site(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildPMV(viewController)
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "to_loc" => @to_loc, "current_qty" => @current_qty, "current_item" => @current_item, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][to_loc(==height)]-margin-[current_item(==height)][current_qty(==height)]-margin-[submit(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
			
		end

		viewController
	end

	def buildPUL(viewController)
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "current_qty" => @current_qty, "tag_num" => @tag_num, "qty" => @qty,"current_item" => @current_item, "current_qty" => @current_qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][item_num(==height)]-margin-[from_loc(==height)][to_loc(==height)]-margin-[qty(==height)][current_qty(==height)]-margin-[current_item(==height)]-margin-[submit(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[qty(==half_width)]-[current_qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildSkidLabel(viewController)
		@skid_num.becomeFirstResponder
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "skid_num" => @skid_num, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[skid_num(==height)]-margin-[submit(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[submit]-10-|"
			sharedLayoutParameters(layout)
		end
	end

	def sharedLayoutParameters(layout, *params)
		layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
		layout.horizontal "|-0-[alert_area(==400)]-0-|"
		layout.horizontal "|-0-[table(==400)]-[header]-10-|"
		unless params.empty?
			layout.horizontal "|-#{params[0][:left_margin]}-[submit]-10-|"
		 	layout.horizontal "|-#{params[0][:left_margin]}-[header]-10-|"
		end
	end

	def createTable(view)
		@table = UITableView.new
		@table.dataSource = view
		@table.delegate = view
	end

	def createTextField
		textField = UITextField.new
		textField.clearButtonMode = UITextFieldViewModeWhileEditing
		textField
	end

	def createView
		UIView.new
	end

	def createLabel
		UILabel.new
	end

	def createTextView
		UITextView.new
	end

	def clearTextFields
		@item_num.text = ""
		@from_loc.text = ""
		@tag_num.text = ""
		@to_loc.text = ""
		@qty.text = ""
		@from_site.text = ""
		@to_site.text = ""
		@skid_num.text = ""
		@remarks.text = ""
		@lot.text = ""
		@current_qty.text = ""
		@current_item.text = ""
		@new_pallet = false
	end
	
	#These functions update the bottom left of the main screen for alert notifications
	def buildAlertArea(view)
		@text_area = createLabel
		@text_area.lineBreakMode = true
		@text_area.numberOfLines = 14
		@text_area.adjustsFontSizeToFitWidth = true
		@text_area.textAlignment = UITextAlignmentCenter
		@text_area.textColor = @text_area.color = UIColor.colorWithRed(0.0, green: 0.13, blue: 0.36, alpha: 0.9)

		Motion::Layout.new do |layout|
			layout.view view
			layout.subviews "text_area" => @text_area
			layout.metrics "margin" => 5
			layout.vertical "|-10-[text_area]-(>=5)-|"
			layout.horizontal "|-10-[text_area]-10-|"
		end
	end

	def updateAlertArea(update_type="success", message=nil)
		if update_type == "success"
			@text_area.text = "Transaction Successful: \n #{@header.text} \n Item Num: \t #{@item_num.text}\nQty: \t #{@qty.text}\nFrom Loc: \t #{@from_loc.text}\nTo Loc: \t #{@to_loc.text}"
		else
			@text_area.text = "Transaction Failed: \n #{message}"
		end

		NSTimer.scheduledTimerWithTimeInterval(5.0, target:self, selector: "clearAlertArea", userInfo: nil, repeats: false)
	end

	def clearAlertArea
		@text_area.text =  ""
	end
	###

	def addSharedAttributes(object, placeholder, pickerView=false)
		object.placeholder = placeholder
		object.adjustsFontSizeToFitWidth = true
		object.textAlignment = UITextAlignmentCenter
		object.accessibilityLabel = placeholder
		
		if pickerView == true
			object.inputView = @picker
		end
	end

	def disableItemNumField
		@item_num.userInteractionEnabled = false
		@item_num.placeholder = 'Item Number - Informational Only'
	end

	def enableItemNumField
		@item_num.placeholder = "Item Number"
		@item_num.userInteractionEnabled = true
	end

	def initUIPickerView(view)
		@picker = UIPickerView.new
		@picker.frame = CGRectMake(20, 100, 260, 120)
		@picker.delegate = view
		@picker.dataSource = view
	end

	

	def textFieldDidBeginEditing(textField)
	end
	
	def textFieldDidEndEditing(textfield)
		textfield.superview.nextResponder.showSpinner
		if textfield === @tag_num
			unless @tag_num.text.empty? || @new_pallet
				APIRequest.new.get('tag_details', {tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
					if result["success"] == true 
						if @header.text.match(/PLO/).nil?
							@from_loc.text = result["result"]["ttloc"]
						else
							@to_loc.text = result["result"]["ttloc"]
						end

						@item_num.text = result["result"]["ttitem"]
						@from_site.text = result["result"]["ttsite"]
						@to_site.text = result["result"]["ttsite"]
						@current_qty.text = "Current tag qty: #{result["result"]["ttqtyloc"].to_i}"
						@current_item.text = "#{result["result"]["ttdesc1"]}"
					else
						self.updateAlertArea("failure", result["result"]["ttitem"])
					end
					textfield.superview.nextResponder.stopSpinner
				end	
			end
		elsif textfield === @item_num
			APIRequest.new.get('item_location', {item_num: @item_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				default_location = result["Location"]
				if @header.text.match(/PLO/).nil?
					@from_loc.text = default_location
				else
					@to_loc.text.empty? ? @to_loc.text = default_location : @from_loc.text = default_location
				end
				textfield.superview.nextResponder.stopSpinner
			end
		end
	end

end