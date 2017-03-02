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

	def initWithView(view)
		createTable(view)
		@nav_bar_height = view.navigationController.navigationBar.frame.origin.y + view.navigationController.navigationBar.frame.size.height
		self
	end

	def buildLogIn(viewController)
		@username = createTextField
		addSharedAttributes(@username, 'Username')

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
		addSharedAttributes(@item_num, 'Item Number')

		@tag_num = createTextField
		addSharedAttributes(@tag_num, 'Tag Number')

		@qty = createTextField
		addSharedAttributes(@qty, 'Move Qty')

		@from_loc = createTextField
		addSharedAttributes(@from_loc, 'From Location')

		@to_loc = createTextField
		addSharedAttributes(@to_loc, 'To Location', true)

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

		@cell_bg = createView
		@cell_bg.backgroundColor = UIColor.colorWithRed(0.48, green: 0.70, blue: 0.56, alpha: 0.8)

		@submit = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@submit.setTitle('Submit', forState:UIControlStateNormal)
		@submit.setTitle('Submiting...', forState:UIControlStateSelected)
		@submit.addTarget(viewController, action: 'submit', forControlEvents:UIControlEventTouchUpInside)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end
		viewController
	end

	def buildPUL(viewController)
		#@header.text = "PUL"


		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "qty" => @qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[item_num(==height)]-margin-[tag_num(==height)]-margin-[qty(==height)]-margin-[from_loc(==height)]-margin-[to_loc(==height)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildPDL(viewController)
		#@header.text = "PDL"

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "from_loc" => @from_loc, "to_loc" => @to_loc, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[item_num(==height)]-margin-[tag_num(==height)]-margin-[from_loc(==height)]-margin-[to_loc(==height)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildPMV(viewController)
		#@header.text = "PMV"

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "to_loc" => @to_loc, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)]-margin-[to_loc(==height)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildPCT(viewController)
		#@header.text = "PCT"

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "to_loc" => @to_loc, "lot" => @lot, "tag_num" => @tag_num, "qty" => @qty, "remarks" => @remarks, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[item_num(==height)]-margin-[to_loc(==height)]-margin-[lot(==height)]-margin-[tag_num(==height)]-margin-[qty(==height)]-margin-[remarks(==50)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildPLO(viewController)
		#@header.text = "PLO"

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "qty" => @qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "from_site" => @from_site, "to_site" => @to_site, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[item_num(==height)]-margin-[qty(==height)]-margin-[from_site(==height)]-margin-[to_site(==height)]-margin-[from_loc(==height)]-margin-[to_loc(==height)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildSkidLabel(viewController)
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "skid_num" => @skid_num, "submit" => @submit, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50
			# layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[skid_num(==height)]-margin-[submit(==height)]-(>=10)-|"
			# layout.horizontal "|-0-[alert_area(==400)]-0-|"
			# layout.horizontal "|-0-[table(==400)]-[header]-0-|"
			sharedLayoutParameters(layout)
		end
	end

	def sharedLayoutParameters(layout)
		layout.vertical "|-0-[table(>=500)]-[alert_area]-0-|"
		layout.horizontal "|-0-[alert_area(==400)]-0-|"
		layout.horizontal "|-0-[table(==400)]-[header]-0-|"
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
	
	#These functions update the bottom left of the main screen for alert notifications
	def buildAlertArea(view)
		@success_lbl = createLabel
		@success_lbl.textAlignment = UITextAlignmentCenter

		@trans_type_lbl = createLabel
		@trans_type_lbl.textAlignment = UITextAlignmentCenter

		@item_msg_lbl = createLabel
		@qty_msg_lbl = createLabel
		@from_msg_lbl = createLabel
		@to_msg_lbl = createLabel

		[@success_lbl, @trans_type_lbl, @item_msg_lbl, @qty_msg_lbl, @from_msg_lbl, @to_msg_lbl].each do |lbl|
			lbl.textColor = UIColor.colorWithRed(0.05, green: 0.35, blue: 0.81, alpha: 0.8)
		end
		


		Motion::Layout.new do |layout|
			layout.view view
			layout.subviews "success_lbl" => @success_lbl, "trans_type_lbl" => @trans_type_lbl, "item_msg_lbl" => @item_msg_lbl, 
											"qty_msg_lbl" => @qty_msg_lbl, "from_msg_lbl" => @from_msg_lbl, "to_msg_lbl" => @to_msg_lbl
			layout.metrics "margin" => 5
			layout.vertical "|-10-[success_lbl]-[trans_type_lbl]-[item_msg_lbl]-[qty_msg_lbl]-[from_msg_lbl]-[to_msg_lbl]-(>=10)-|"
			layout.horizontal "|-0-[success_lbl]-0-|"
			layout.horizontal "|-0-[trans_type_lbl]-0-|"
			layout.horizontal "|-0-[item_msg_lbl]-0-|"
			layout.horizontal "|-0-[qty_msg_lbl]-0-|"
			layout.horizontal "|-0-[from_msg_lbl]-0-|"
			layout.horizontal "|-0-[to_msg_lbl]-0-|"
		end
	end

	def updateAlertArea(update_type="success", message=nil)
		if update_type == "success"
			@success_lbl.text = "Transaction Successful:"
			@trans_type_lbl.text = @header.text
			@item_msg_lbl.text = "Item Num: \t #{@item_num.text}"
			@qty_msg_lbl.text = "Qty: \t #{@qty.text}"
			@from_msg_lbl.text = "From Loc: \t #{@from_loc.text}"
			@to_msg_lbl.text = "To Loc: \t #{@to_loc.text}"
		else
			@success_lbl.text = "Transaction Failed:"
			@trans_type_lbl.text = ""
			@item_msg_lbl.text = ""
			@qty_msg_lbl.text = "#{message}"
			@from_msg_lbl.text = ""
			@to_msg_lbl.text = ""
		end
	end

	def clearAlertArea
		@success_lbl.text = ""
		@trans_type_lbl.text = ""
		@item_msg_lbl.text = ""
		@qty_msg_lbl.text = ""
		@from_msg_lbl.text = ""
		@to_msg_lbl.text = ""
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

	def initUIPickerView(view)
		@picker = UIPickerView.new
		@picker.frame = CGRectMake(20, 100, 260, 120)
		@picker.delegate = view
		@picker.dataSource = view
	end
end