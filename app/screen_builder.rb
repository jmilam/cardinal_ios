class ScreenBuilder < UIViewController

	attr_reader :table
	attr_reader :cell_bg
	attr_reader :item_num
	attr_reader :tag_num
	attr_reader :new_tag_num
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
	attr_reader :po_number
	attr_reader :po_items
	attr_reader :label_count
	attr_reader :so_number
	attr_reader :carton_item
	attr_reader :carton_number
	attr_reader :cartons
	attr_reader :line_number
	attr_reader :effective_date
	attr_reader :prod_line
	attr_reader :user_initials
	attr_reader :distribution_num

	def initWithView(view)
		@cartons = Array.new
		@new_pallet = false
		@table = createTable(view)
		@nav_bar_height = view.navigationController.nil? ? 100 : view.navigationController.navigationBar.frame.origin.y + view.navigationController.navigationBar.frame.size.height

		self
	end

	def build_group_label(label_name)
		label_val = createLabel
		label_val.text = label_name
		label_val.backgroundColor = UIColor.grayColor
		label_val.textAlignment = UITextAlignmentCenter
		label_val.textColor = UIColor.whiteColor
		label_val
	end

	def buildLogIn(viewController)
		@header = createLabel
		@header.backgroundColor = UIColor.colorWithRed(0.84, green:0.26, blue: 0.21, alpha: 0.8)

		@footer = createLabel
		@footer.text = "v. #{NSBundle.mainBundle.objectForInfoDictionaryKey("CFBundleShortVersionString")}"
		@footer.backgroundColor = UIColor.colorWithRed(0.84, green:0.26, blue: 0.21, alpha: 0.8)
		@footer.textAlignment = UITextAlignmentCenter
		@footer.textColor = UIColor.whiteColor

		@username = createTextField
		addSharedAttributes(@username, '')
		@username.becomeFirstResponder

		@username_label = build_group_label('Username')

		@password = createTextField
		addSharedAttributes(@password, '')
		@password.secureTextEntry = true

		@password_label = build_group_label('Password')

		@site_num = createTextField
		addSharedAttributes(@site_num, '')

		@site_num_label = build_group_label('Site Num')

		@printer = createTextField
		addSharedAttributes(@printer, '')

		@printer_label = build_group_label('Printer')

		@login = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@login.setTitle('Login', forState:UIControlStateNormal)
		@login.accessibilityLabel = 'Login'
		@login.setTitle('Logging In..', forState:UIControlStateSelected)
		@login.addTarget(viewController, action: 'login', forControlEvents:UIControlEventTouchUpInside)

		@group_1 = create_textfield_group(@username_label, @username, viewController)
		@group_2 = create_textfield_group(@password_label, @password, viewController)
		@group_3 = create_textfield_group(@site_num_label, @site_num, viewController)
		@group_4 = create_textfield_group(@printer_label, @printer, viewController)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "header" => @header, "group_1" => @group_1, "group_2" => @group_2, "group_3" => @group_3, "group_4" => @group_4, "login" => @login, "footer" => @footer
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-125-[group_1(==height)]-margin-[group_2(==height)]-margin-[group_3(==height)]-margin-[group_4(==height)]-margin-[login(==height)]-(>=15)-[footer(==height)]-|"
			layout.horizontal "|-0-[header]-0-|"
			layout.horizontal "|-(>=100)-[group_1(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[group_2(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[group_3(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[group_4(==300)]-(>=100)-|"
			layout.horizontal "|-10-[login]-10-|"
			layout.horizontal "|-0-[footer]-0-|"
		end

		@group_1, @group_2, @group_3, @group_4, = nil, nil, nil, nil
	end

	def buildMainMenu(viewController)
		@alert_area = createView
		buildAlertArea(@alert_area)

		@header = createLabel
		@header.backgroundColor = UIColor.colorWithRed(0.84, green:0.26, blue: 0.21, alpha: 0.8)
		@header.textColor = UIColor.whiteColor
		@header.text = "Select Menu Function..."
		@header.textAlignment = UITextAlignmentCenter

		@tag_num_label = build_group_label('Tag number')
		@po_label = build_group_label('PO Number')
		@new_tag_num_label = build_group_label('Tag number')
		@item_num_label = build_group_label('Item Number')
		@qty_label = build_group_label('Move Qty')
		@from_loc_label = build_group_label('From Location')
		@to_loc_label = build_group_label('To Location')
		@to_site_label = build_group_label('To Site')
		@from_site_label = build_group_label('From Site')
		@skid_label = build_group_label('Skid Label')
		@so_num_label = build_group_label('SO Number')
		@line_num_label = build_group_label('Line Number')
		@carton_item_label = build_group_label('Carton Item #')
		@carton_num_label = build_group_label('Carton #')
		@skid_num_label = build_group_label('Skid Number')
		@prod_line_label = build_group_label('Production Line')
		@date_label = build_group_label('Effective Date (Default Date: Today)')
		@user_initials_label = build_group_label('Employee ID')
		@distribution_num_label = build_group_label('Distribution Number')

		@tag_num = createTextField
		addSharedAttributes(@tag_num, 'Enter Existing Tag Number')
		@tag_num.delegate = self

		@new_tag_num = createTextField
		addSharedAttributes(@new_tag_num, '')
		@new_tag_num.delegate = self 

		@item_num = createTextField
		@item_num.userInteractionEnabled = false
		addSharedAttributes(@item_num, '')
		@item_num.delegate = self

		@qty = createTextField
		addSharedAttributes(@qty, '')

		@from_loc = createTextField
		addSharedAttributes(@from_loc, '')

		@to_loc = createTextField
		addSharedAttributes(@to_loc, '')

		@from_site = createTextField
		addSharedAttributes(@from_site, '')

		@to_site = createTextField
		addSharedAttributes(@to_site, '')

		@lot =createTextField
		addSharedAttributes(@lot, '')

		@remarks = createTextField
		addSharedAttributes(@remarks, '15 letter max')
		@remarks.delegate = self

		@skid_num = createTextField
		addSharedAttributes(@skid_num, '')
		@skid_num.delegate = self

		@po_number = createTextField
		addSharedAttributes(@po_number, '')

		@label_count = createTextField
		addSharedAttributes(@label_count, "How many labels?")

		@so_number = createTextField
		addSharedAttributes(@so_number, "")

		@carton_item = createTextField
		addSharedAttributes(@carton_item, "")
		@carton_item.delegate = self

		@carton_number = createTextField
		addSharedAttributes(@carton_number, "")

		@ship_to = createTextField
		addSharedAttributes(@ship_to, "Ship To...")

		@line_number = createTextField
		addSharedAttributes(@line_number, "")

		@effective_date = createTextField
		addSharedAttributes(@effective_date, "")

		@prod_line = createTextField
		addSharedAttributes(@prod_line, "")

		@user_initials = createTextField
		addSharedAttributes(@user_initials, "")

		@distribution_num = createTextField
		addSharedAttributes(@distribution_num, "Enter Distirbution #")

		@hidden_tag_num = createTextField
		addSharedAttributes(@hidden_tag_num, "")
		@hidden_tag_num.delegate = self
		@hidden_tag_num.hidden = true

		@current_qty = createLabel
		@current_qty.textAlignment = UITextAlignmentCenter
		@current_item = createLabel
		@current_item.textAlignment = UITextAlignmentCenter
		@current_item.numberOfLines = 2
		
		@submitBtn = UIBarButtonItem.alloc.initWithTitle("Submit", style:UIBarButtonItemStylePlain, target:viewController, action: "submit")          
		@nextBtn = UIBarButtonItem.alloc.initWithTitle("Next", style:UIBarButtonItemStylePlain, target:viewController, action: "next")          

		@cell_bg = createView
		@cell_bg.backgroundColor = UIColor.colorWithRed(0.48, green: 0.70, blue: 0.56, alpha: 0.8)

		@new_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@new_button.setTitle('New Tag', forState: UIControlStateNormal)
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

	def buildStartingPoint(viewController)
 	 	viewController.navigationItem.rightBarButtonItem = @nextBtn
 	 	@nextBtn.enabled = true
		@tag_num.userInteractionEnabled = true
		@tag_num.becomeFirstResponder

		if @header.text.downcase.match(/^car/) != nil
			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "so_number" => @so_number, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_number(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[so_number]-10-|"
			end
		elsif @header.text.downcase.match(/^cte/) != nil

			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "carton_num_label" => @carton_num_label, "carton_number" => @carton_number, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[carton_num_label(==height)][carton_number(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[header]-10-|"
				layout.horizontal "|-left_margin-[carton_num_label(==half_width)][carton_number(==half_width)]-10-|"
			end
		elsif @header.text.downcase.match(/plo/) != nil
			@new_tag_num.userInteractionEnabled = true
			@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
			@new_tag_num.becomeFirstResponder
			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "tag_num_group" => @tag_num_group, "new_button" => @new_button, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_group(==height)]-[new_button(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[header]-10-|"
				layout.horizontal "|-left_margin-[new_button(==half_width)]-[tag_num_group(==half_width)]-10-|"
			end
		elsif @header.text.downcase.match(/vmi/) != nil
			@distribution_num.userInteractionEnabled = true
			@distribution_num.becomeFirstResponder

			@tag_view_area = UIScrollView.new

			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "distribution_num_label" => @distribution_num_label, "distribution_num" => @distribution_num, "hidden_tag_num" => @hidden_tag_num, "tag_view_area" => @tag_view_area, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[distribution_num_label(==height)][distribution_num(==height)]-[hidden_tag_num(==height)]-[tag_view_area]-10-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[header]-10-|"
				layout.horizontal "|-left_margin-[distribution_num_label(==half_width)][distribution_num(==half_width)]-10-|"
				layout.horizontal "|-left_margin-[hidden_tag_num]-10-|"
				layout.horizontal "|-left_margin-[tag_view_area]-10-|"
			end
		else
			@tag_num_label.text = 'Enter Tag Number'
			@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "tag_num_label" => @tag_num_label, "tag_num" => @tag_num, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num_label(==height)][tag_num(==height)]-(>=10)-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[header]-10-|"
				layout.horizontal "|-left_margin-[tag_num_label(==half_width)][tag_num(==half_width)]-10-|"
			end
		end
	end

	def buildPCT(viewController, current_text)
		viewController.stopSpinner
		@qty_label.text = "Updated Qty"
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@new_tag_num.text = current_text
		@new_tag_num.userInteractionEnabled = false
		@qty.becomeFirstResponder
		disableItemNumField

		@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController)
		@qty_group = create_textfield_group(@qty_label, @qty, viewController)


		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num_group" => @item_num_group, "tag_num_group" => @tag_num_group, "qty_group" => @qty_group, "current_qty" => @current_qty, "current_item" => @current_item, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20, "quarter_width" => ((viewController.view.frame.size.width - 410) / 4), "left_padding" => (((viewController.view.frame.size.width - 410) / 2)) + 410
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num_group(==height)]-[item_num_group(==height)]-margin-[qty_group(==height)]-[current_item(==height)]-margin-[current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_group(==half_width)]-[item_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[qty_group(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_padding-[current_qty(==half_width)]-10-|"

			sharedLayoutParameters(layout, {left_margin: 410})
		end

		@tag_num_group, @item_num_group, @qty_group = nil, nil, nil
		viewController
	end

	def buildPDL(viewController, current_text)
		viewController.stopSpinner
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@new_tag_num.becomeFirstResponder
		@new_tag_num.text = current_text
		@new_tag_num.userInteractionEnabled = false
		disableItemNumField

		@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController)
		@from_loc_group = create_textfield_group(@from_loc_label, @from_loc, viewController) 
		@to_loc_group = create_textfield_group(@to_loc_label, @to_loc, viewController) 

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num_group" => @item_num_group, "tag_num_group" => @tag_num_group, "current_qty" => @current_qty, "current_item" => @current_item, "from_loc" => @from_loc_group, "to_loc" => @to_loc_group, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_group(==height)][item_num_group(==height)]-margin-[from_loc(==height)][current_item(==height)]-margin-[to_loc(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_group(==half_width)]-[item_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[to_loc(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		@tag_num_group, @item_num_group, @from_loc_group, @to_loc_group = nil, nil, nil, nil
		@from_loc.userInteractionEnabled = false
		@to_loc.userInteractionEnabled = true
		viewController
	end

	def buildPLO(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@new_tag_num.text = current_text

		@qty.placeholder = "Qty"
		@qty_label.text = "Quantity"
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		@from_site.userInteractionEnabled = false
		@to_site.userInteractionEnabled = false
		@to_loc.userInteractionEnabled = false
		@new_tag_num.userInteractionEnabled = false
		enableItemNumField
		@item_num.becomeFirstResponder

		@blank_space = createLabel
		@qty_group = create_textfield_group(@qty_label, @qty, viewController)
		@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController, true)
		@from_loc_group = create_textfield_group(@from_loc_label, @from_loc, viewController) 
		@to_loc_group = create_textfield_group(@to_loc_label, @to_loc, viewController) 
		@from_site_group = create_textfield_group(@from_site_label, @from_site, viewController) 
		@to_site_group = create_textfield_group(@to_site_label, @to_site, viewController) 

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "blank_space" => @blank_space, "item_num_group" => @item_num_group, "tag_num_group" => @tag_num_group, "qty_group" => @qty_group, "current_qty" => @current_qty, "current_item" => @current_item, "from_loc_group" => @from_loc_group, "to_loc_group" => @to_loc_group, "from_site_group" => @from_site_group, "to_site_group" => @to_site_group, "new_button" => @new_button, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[item_num_group(==height)]-[qty_group(==height)][tag_num_group(==height)]-margin-[from_site_group(==height)][to_site_group(==height)]-margin-[from_loc_group(==height)][to_loc_group(==height)]-margin-[current_item(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[item_num_group]-10-|"
			layout.horizontal "|-left_margin-[qty_group(==half_width)]-[tag_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_site_group(==half_width)]-[to_site_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc_group(==half_width)]-[to_loc_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildPMV(viewController, current_text)
		viewController.stopSpinner
		@from_loc.userInteractionEnabled = false
		@to_loc.userInteractionEnabled = true
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@new_tag_num.text = current_text
		@new_tag_num.userInteractionEnabled = false
		@to_loc.becomeFirstResponder
		disableItemNumField

		@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController)
		@from_loc_group = create_textfield_group(@from_loc_label, @from_loc, viewController) 
		@to_loc_group = create_textfield_group(@to_loc_label, @to_loc, viewController)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num_group" => @item_num_group, "tag_num_group" => @tag_num_group, "to_loc_group" => @to_loc_group, "from_loc_group" => @from_loc_group, "current_qty" => @current_qty, "current_item" => @current_item, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_group(==height)][current_item(==height)]-margin-[to_loc_group(==height)][item_num_group(==height)]-margin-[from_loc_group(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_group(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[to_loc_group(==half_width)]-[item_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc_group(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
			
		end

		viewController
	end

	def buildPUL(viewController, current_text)
		viewController.stopSpinner
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@from_loc.userInteractionEnabled = false
		@to_loc.userInteractionEnabled = true
		@new_tag_num.text = current_text
		@new_tag_num.userInteractionEnabled = false
		@new_tag_num.becomeFirstResponder
		disableItemNumField

		@qty_label.text = "Qty"

		@tag_num_group = create_textfield_group(@new_tag_num_label, @new_tag_num, viewController) 
		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController)
		@from_loc_group = create_textfield_group(@from_loc_label, @from_loc, viewController) 
		@to_loc_group = create_textfield_group(@to_loc_label, @to_loc, viewController)
		@qty_group = create_textfield_group(@qty_label, @qty, viewController)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num_group" => @item_num_group, "tag_num_group" => @tag_num_group, "qty_group" => @qty_group ,"current_item" => @current_item, "current_qty" => @current_qty, "from_loc_group" => @from_loc_group, "to_loc_group" => @to_loc_group, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_group(==height)][item_num_group(==height)]-margin-[from_loc_group(==height)][to_loc_group(==height)]-margin-[qty_group(==height)][current_qty(==height)]-margin-[current_item(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_group(==half_width)]-[item_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc_group(==half_width)]-[to_loc_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[qty_group(==half_width)]-[current_qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildTPT(viewController, current_text)
		@tag_num.userInteractionEnabled = true
		@tag_num.placeholder = ''
		@tag_num_label.text = 'Enter Tag Number'
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@tag_num.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num_label" => @tag_num_label, "tag_num" => @tag_num, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410,  "half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_label(==height)][tag_num(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_label(==half_width)][tag_num(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildGLB(viewController, current_text)
		@tag_num_label.text = "Enter Label Wording..."
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@remarks.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num_label" => @tag_num_label, "remarks" => @remarks, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410,  "half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num_label(==height)][remarks(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num_label(==half_width)][remarks(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildSkidLabel(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@skid_num.becomeFirstResponder
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "skid_label" => @skid_label, "skid_num" => @skid_num, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[skid_label(==height)][skid_num(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[skid_label(==half_width)][skid_num(==half_width)]-10-|"
			sharedLayoutParameters(layout,{left_margin: 410})
		end
	end

	def buildPOR1(viewController, current_text)
 	 	viewController.navigationItem.rightBarButtonItem = @nextBtn
 	 	@nextBtn.enabled = true
		@po_number.userInteractionEnabled = true
		@po_number.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "po_label" => @po_label, "po_number" => @po_number, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[po_label(==height)][po_number(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[po_label(==half_width)][po_number(==half_width)]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
			#sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildPOR2(viewController, data_hash)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true

		@po_number.userInteractionEnabled = false
		@data_container = UIScrollView.new

		@table_header = UIView.new
		@table_header.backgroundColor = UIColor.grayColor

		label = UILabel.alloc.initWithFrame([[0,0],[60,30]])
		label.numberOfLines = 2
		label.text = "Line\nNum"
		label.adjustsFontSizeToFitWidth = true
		label.textColor = UIColor.whiteColor
		label.textAlignment = UITextAlignmentCenter

		label0 = UILabel.alloc.initWithFrame([[60,0],[100,30]])
		label0.numberOfLines = 2
		label0.text = "Item Num"
		label0.adjustsFontSizeToFitWidth = true
		label0.textColor = UIColor.whiteColor
		label0.textAlignment = UITextAlignmentCenter

		label1 = UILabel.alloc.initWithFrame([[170,0],[100,30]])
		label1.numberOfLines = 2
		label1.text = "Location"
		label1.adjustsFontSizeToFitWidth = true
		label1.textColor = UIColor.whiteColor
		label1.textAlignment = UITextAlignmentCenter

		label2 = UILabel.alloc.initWithFrame([[280,0],[125,30]])
		label2.numberOfLines = 2
		label2.text = "Qty Recv"
		label2.adjustsFontSizeToFitWidth = true
		label2.textColor = UIColor.whiteColor
		label2.textAlignment = UITextAlignmentCenter

		label3 = UILabel.alloc.initWithFrame([[415,0],[75,30]])
		label3.text = "Multiplier"
		label3.adjustsFontSizeToFitWidth = true
		label3.textColor = UIColor.whiteColor
		label3.textAlignment = UITextAlignmentCenter

		label4 = UILabel.alloc.initWithFrame([[500,0],[100,30]])
		label4.text = "Open Qty"
		label4.adjustsFontSizeToFitWidth = true
		label4.textColor = UIColor.whiteColor
		label4.textAlignment = UITextAlignmentCenter

		@table_header.addSubview(label)
		@table_header.addSubview(label0)
		@table_header.addSubview(label1)
		@table_header.addSubview(label2)
		@table_header.addSubview(label3)
		@table_header.addSubview(label4)


		label = nil
		label0 = nil
		label1 = nil
		label2 = nil
		label3 = nil
		label4 = nil

		@por_loc = []
		@locations = UIPickerView.new
		@locations.frame = CGRectMake(20, 100, 260, 120)
		@locations.delegate = self
		@locations.dataSource = self

		position = 0
		data_hash[:po_items].each do |data|
			@por_loc = data_hash[:locations].uniq
			new_view = UIView.new
			new_view.frame = [[0,position],[600,100]]

			longGesture = UILongPressGestureRecognizer.alloc.initWithTarget(self, action: 'handleLongPressGestures:')
			longGesture.minimumPressDuration = 0.5
			new_view.addGestureRecognizer(longGesture)

			label1 = UILabel.alloc.initWithFrame([[0, 0], [60,20]])

			label2 = UILabel.alloc.initWithFrame([[60,0],[100,30]])
			label2.adjustsFontSizeToFitWidth = true


			label3 = createTextField
			addSharedAttributes(label3, "Location..")
			label3.frame = [[170,0], [100,30]]
			label3.layer.borderWidth= 0.0
			label3.delegate = self
			label3.inputView = @locations
			

			label4 = createTextField
			addSharedAttributes(label4, "Qty receiving?")
			label4.frame = [[280,0],[125,30]]
			label4.layer.borderWidth= 0.0

			label5 = createTextField
			addSharedAttributes(label5, "Multiplier")
			label5.frame = [[415,0],[75,30]]
			label5.layer.borderWidth= 0.0

			label6 = UILabel.alloc.initWithFrame([[500,0],[100,30]] )
			label6.adjustsFontSizeToFitWidth = true

			breakline = UILabel.new
			breakline.backgroundColor = UIColor.blackColor
			breakline.frame = [[0,39], [600,1]]

			label1.text = data["ttline"].to_s
			label2.text = data["ttitem"]
			# p data_hash[:locations][data["ttitem"]]
			label3.text = data_hash[:default_locations][data["ttitem"]][0]
			label5.text = "1"
			label6.text = "Open Qty: " + data["ttqtyopen"].to_i.to_s 

			new_view.addSubview(label1)
			new_view.addSubview(label2)
			new_view.addSubview(label3)
			new_view.addSubview(label4)
			new_view.addSubview(label5)
			new_view.addSubview(label6)
			new_view.addSubview(breakline)
			

			@data_container.addSubview(new_view)

			position += 50
			label1 = nil
			label2 = nil
			label3 = nil
			label4 = nil
			label5 = nil
			new_view = nil
			breakline = nil
			longGesture = nil
		end

		@data_container.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "po_label" => @po_label, "po_number" => @po_number, "table_header" => @table_header, "data_container" => @data_container, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410,  "half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[po_label(==height)][po_number(==height)]-[table_header(==height)]-[data_container(==300)]-(>=10)-|"
			layout.horizontal "|-left_margin-[po_label(==half_width)][po_number(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[table_header]-10-|"
			layout.horizontal "|-left_margin-[data_container]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
	end

	def buildCAR1(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @nextBtn
		@nextBtn.enabled = true
		@so_number.becomeFirstResponder
		@so_number.userInteractionEnabled = true
		@line_number.userInteractionEnabled = true

		@so_num_group = create_textfield_group(@so_num_label, @so_number, viewController) 
		@line_num_group = create_textfield_group(@line_num_label, @line_number, viewController)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "so_num_group" => @so_num_group, "line_num_group" => @line_num_group, "carton_item_label" => @carton_item_label, "carton_item" => @carton_item, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20, "long_half_width" => ((viewController.view.frame.size.width - 410) / 2) 
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_group(==height)][line_num_group(==height)]-margin-[carton_item_label(==height)][carton_item(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[so_num_group(==half_width)]-[line_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[carton_item_label(==long_half_width)][carton_item(==long_half_width)]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
	end

	def buildCAR2(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		viewController.view.nextResponder.showSpinner
		@so_number.userInteractionEnabled = false
		@line_number.userInteractionEnabled = false

		@carton_item.becomeFirstResponder

		@data_container = UIScrollView.new
		@table_header = UIView.new
		@table_header.backgroundColor = UIColor.grayColor

		label = UILabel.alloc.initWithFrame([[0,0],[50,30]])
		label.numberOfLines = 2
		label.text = "Qty to\nPack"
		label.adjustsFontSizeToFitWidth = true
		label.textColor = UIColor.whiteColor
		label.textAlignment = UITextAlignmentCenter

		label0 = UILabel.alloc.initWithFrame([[80,0],[40,30]])
		label0.numberOfLines = 2
		label0.text = "Qty\nPacked"
		label0.adjustsFontSizeToFitWidth = true
		label0.textColor = UIColor.whiteColor
		label0.textAlignment = UITextAlignmentCenter

		label1 = UILabel.alloc.initWithFrame([[130,0],[40,30]])
		label1.numberOfLines = 2
		label1.text = "Qty Ordered"
		label1.adjustsFontSizeToFitWidth = true
		label1.textColor = UIColor.whiteColor
		label1.textAlignment = UITextAlignmentCenter

		label2 = UILabel.alloc.initWithFrame([[180,0],[40,30]])
		label2.numberOfLines = 2
		label2.text = "Qty Shipped"
		label2.adjustsFontSizeToFitWidth = true
		label2.textColor = UIColor.whiteColor
		label2.textAlignment = UITextAlignmentCenter

		label3 = UILabel.alloc.initWithFrame([[230,0],[80,30]])
		label3.text = "Carton #"
		label3.adjustsFontSizeToFitWidth = true
		label3.textColor = UIColor.whiteColor
		label3.textAlignment = UITextAlignmentCenter

		label4 = UILabel.alloc.initWithFrame([[320,0],[80,30]])
		label4.text = "Skid #"
		label4.adjustsFontSizeToFitWidth = true
		label4.textColor = UIColor.whiteColor
		label4.textAlignment = UITextAlignmentCenter

		label5 = UILabel.alloc.initWithFrame([[410,0],[60,30]])
		label5.text = "Length"
		label5.adjustsFontSizeToFitWidth = true
		label5.textColor = UIColor.whiteColor
		label5.textAlignment = UITextAlignmentCenter

		label6 = UILabel.alloc.initWithFrame([[480,0],[120,30]])
		label6.text = "Item Desc."
		label6.adjustsFontSizeToFitWidth = true
		label6.textColor = UIColor.whiteColor
		label6.textAlignment = UITextAlignmentCenter

		@table_header.addSubview(label0)
		@table_header.addSubview(label1)
		@table_header.addSubview(label2)
		@table_header.addSubview(label3)
		@table_header.addSubview(label4)
		@table_header.addSubview(label5)
		@table_header.addSubview(label6)
		@table_header.addSubview(label)


		label0 = nil
		label1 = nil
		label2 = nil
		label3 = nil
		label4 = nil
		label5 = nil
		label6 = nil
		label = nil

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "so_num_group" => @so_num_group, "line_num_group" => @line_num_group, "carton_item_label" => @carton_item_label, "carton_item" => @carton_item, "table_header" => @table_header, "data_container" => @data_container, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20, "long_half_width" => ((viewController.view.frame.size.width - 410) / 2) 
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_group(==height)][line_num_group(==height)]-margin-[carton_item_label(==height)][carton_item(==height)]-margin-[table_header(==30)]-[data_container(==450)]-(>=10)-|"
			layout.horizontal "|-left_margin-[so_num_group(==half_width)]-[line_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[carton_item_label(==long_half_width)][carton_item(==long_half_width)]-10-|"
			layout.horizontal "|-left_margin-[table_header]-10-|"
			layout.horizontal "|-left_margin-[data_container]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
		@table_header = nil

		APIRequest.new.get('sales_order_details', {so_number: @so_number.text, line_number: @line_number.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			breakline = UILabel.new
			breakline.backgroundColor = UIColor.blackColor
			 if result["status"] == "Good"
			  	position = 0
			  	result["Lines"].each do |line|
			  		new_view = UIView.new
			  		new_view.frame = [[0,position],[600,50]]

						label2 = createTextField
						addSharedAttributes(label2, "Qty")
						label2.frame = [[0,0], [70,30]]
						label2.layer.borderWidth= 0.0
						

						label9 = UILabel.alloc.initWithFrame([[80,0],[40,30]])
						label9.adjustsFontSizeToFitWidth = true
						label9.textAlignment = UITextAlignmentCenter

						label3 = UILabel.alloc.initWithFrame([[130,0],[40,30]])
						label3.adjustsFontSizeToFitWidth = true
						label3.textAlignment = UITextAlignmentCenter

						label4 = UILabel.alloc.initWithFrame([[180,0],[40,30]])
						label4.adjustsFontSizeToFitWidth = true
						label4.textAlignment = UITextAlignmentCenter

						label5 = UILabel.alloc.initWithFrame([[230,0],[80,30]])
						label5.adjustsFontSizeToFitWidth = true
						label5.textAlignment = UITextAlignmentCenter

						label6 = UILabel.alloc.initWithFrame([[320,0],[80,30]])
						label6.adjustsFontSizeToFitWidth = true
						label6.textAlignment = UITextAlignmentCenter

						label7 = UILabel.alloc.initWithFrame([[410,0],[60,30]])
						label7.adjustsFontSizeToFitWidth = true
						label7.textAlignment = UITextAlignmentCenter

						label8 = UILabel.alloc.initWithFrame([[480,0],[120,30]])
						label8.adjustsFontSizeToFitWidth = true
						label8.textAlignment = UITextAlignmentCenter

			  		label3.text = "#{line["ttqtyord"]}"
						label4.text = "#{line["ttqtyshp"]}"
						label5.text = "#{line["ttcarton"]}"
						label6.text = "#{line["ttskid"]}"
						label7.text = "#{line["ttlength"]}"
						label8.text = "#{line["ttdesc"]}"
						label9.text = "#{line["ttqtypck"]}"

						new_view.addSubview(label2)
						new_view.addSubview(label3)
						new_view.addSubview(label4)
						new_view.addSubview(label5)
						new_view.addSubview(label6)
						new_view.addSubview(label7)
						new_view.addSubview(label8)
						new_view.addSubview(label9)

			  		@data_container.addSubview(new_view)

			  		position += 50
						label2 = nil
						label3 = nil
						label4 = nil
						label5 = nil
						label6 = nil
						label7 = nil
						label8 = nil
						label9 = nil
						new_view = nil
			  	end

				@data_container.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)
			end
			viewController.view.nextResponder.stopSpinner
		end	
	end

	def buildSKD1(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @nextBtn
		@nextBtn.enabled = true
		@so_number.becomeFirstResponder

		@so_num_group = create_textfield_group(@so_num_label, @so_number, viewController, true) 

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "so_num_group" => @so_num_group, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) 
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_group(==height)]-(>=10)-|"
			layout.horizontal "|-0-[alert_area(==400)]-0-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
			layout.horizontal "|-left_margin-[so_num_group(==half_width)]-10-|"
		end
	end

	def buildSKD2(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		viewController.view.nextResponder.showSpinner

		@detail_data = UIScrollView.new

		APIRequest.new.get('skid_create_cartons', {so_number: @so_number.text, site: UIApplication.sharedApplication.delegate.site.downcase, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			viewController.view.nextResponder.stopSpinner

			if result["success"]
				position = 0
				result["result"].each do |data|
					cartonTap = UITapGestureRecognizer.alloc.initWithTarget(self, action: "addCarton:")
					cartonTap.delegate = self

					data = data["ttcar"].split(/\|/)
					new_view = UIView.new
					new_view.frame = [[0,position],[600,80]]
					new_view.addGestureRecognizer(cartonTap)
					label1 = UILabel.alloc.initWithFrame([[50, 10],[200,30]])
					label3 = UILabel.alloc.initWithFrame([[50, 40], [200,20]])
					breakline = UILabel.new
					breakline.backgroundColor = UIColor.blackColor
					breakline.frame = [[0,79], [600,1]]

					label1.text = data[0].match(/[^i]+/)[0]
					label3.text = data[4]
					new_view.addSubview(label1)
					new_view.addSubview(label3)
					new_view.addSubview(breakline)
					@detail_data.addSubview(new_view)
					position += 80
					label1 = nil
					label3 = nil
					breakline = nil
					new_view = nil
					cartonTap = nil
				end

				@detail_data.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)

				Motion::Layout.new do |layout|
					layout.view viewController.view
					layout.subviews "table" => @table, "header" => @header, "so_num_label" => @so_num_label, "sales_order" => @so_number, "skid_num_label" => @skid_num_label, "skid_num" => @skid_num, "detail_data" => @detail_data, "alert_area" => @alert_area
					layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2)
					layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
					layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_label(==height)][sales_order(==height)]-margin-[skid_num_label(==height)][skid_num(==height)]-margin-[detail_data(==500)]-(>=10)-|"
					layout.horizontal "|-0-[alert_area(==400)]-0-|"
					layout.horizontal "|-0-[table(==400)]-[header]-10-|"
					layout.horizontal "|-left_margin-[header]-10-|"
					layout.horizontal "|-left_margin-[so_num_label(==half_width)][sales_order(==half_width)]-10-|"
					layout.horizontal "|-left_margin-[skid_num_label(==half_width)][skid_num(==half_width)]-10-|"
					layout.horizontal "|-left_margin-[detail_data]-10-|"
				end
			else
				App.alert result["result"]
				buildSKD1(viewController, current_text)

			end
		end
	end

	def buildGenericView(viewController, current_text)
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "current_qty" => @current_qty, "tag_num" => @tag_num, "qty" => @qty,"current_item" => @current_item, "current_qty" => @current_qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-(>=10)-|"
			sharedLayoutParameters(layout)
		end

		viewController
	end

	def buildSHP1(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @nextBtn
		@nextBtn.enabled = true
		@so_number.becomeFirstResponder
		@so_number.userInteractionEnabled = true

		@so_num_group = create_textfield_group(@so_num_label, @so_number, viewController, true)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "so_num_group" => @so_num_group, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) - 20)
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_group(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[so_num_group(==half_width)]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
	end

	def buildSHP2(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = nil

		viewController.view.nextResponder.showSpinner

		@detail_data = UIScrollView.new
		@table_header = UIView.new
		@table_header.backgroundColor = UIColor.grayColor
		breakline = UILabel.new
		breakline.backgroundColor = UIColor.blackColor

		label = UILabel.alloc.initWithFrame([[0,0],[40,30]])
		label.numberOfLines = 2
		label.text = "Line #"
		label.adjustsFontSizeToFitWidth = true
		label.textColor = UIColor.whiteColor
		label.textAlignment = UITextAlignmentCenter

		label0 = UILabel.alloc.initWithFrame([[50,0],[70,30]])
		label0.numberOfLines = 2
		label0.text = "Item"
		label0.adjustsFontSizeToFitWidth = true
		label0.textColor = UIColor.whiteColor
		label0.textAlignment = UITextAlignmentCenter

		label1 = UILabel.alloc.initWithFrame([[130,0],[40,30]])
		label1.numberOfLines = 2
		label1.text = "Qty Ordered"
		label1.adjustsFontSizeToFitWidth = true
		label1.textColor = UIColor.whiteColor
		label1.textAlignment = UITextAlignmentCenter

		label2 = UILabel.alloc.initWithFrame([[180,0],[40,30]])
		label2.numberOfLines = 2
		label2.text = "Qty Shipped"
		label2.adjustsFontSizeToFitWidth = true
		label2.textColor = UIColor.whiteColor
		label2.textAlignment = UITextAlignmentCenter

		label3 = UILabel.alloc.initWithFrame([[230,0],[40,30]])
		label3.numberOfLines = 2
		label3.text = "Open Qty"
		label3.adjustsFontSizeToFitWidth = true
		label3.textColor = UIColor.whiteColor
		label3.textAlignment = UITextAlignmentCenter

		label4 = UILabel.alloc.initWithFrame([[280,0],[50,30]])
		label4.numberOfLines = 2
		label4.text = "Qty Scanned"
		label4.adjustsFontSizeToFitWidth = true
		label4.textColor = UIColor.whiteColor
		label4.textAlignment = UITextAlignmentCenter

		label5 = UILabel.alloc.initWithFrame([[350,0],[50,30]])
		label5.numberOfLines = 2
		label5.text = "Qty To Ship"
		label5.adjustsFontSizeToFitWidth = true
		label5.textColor = UIColor.whiteColor
		label5.textAlignment = UITextAlignmentCenter

		label6 = UILabel.alloc.initWithFrame([[410,0],[70,30]])
		label6.text = "Location"
		label6.adjustsFontSizeToFitWidth = true
		label6.textColor = UIColor.whiteColor
		label6.textAlignment = UITextAlignmentCenter

		label7 = UILabel.alloc.initWithFrame([[490,0],[70,30]])
		label7.text = "Tag/Ref"
		label7.adjustsFontSizeToFitWidth = true
		label7.textColor = UIColor.whiteColor
		label7.textAlignment = UITextAlignmentCenter

		@table_header.addSubview(label0)
		@table_header.addSubview(label1)
		@table_header.addSubview(label2)
		@table_header.addSubview(label3)
		@table_header.addSubview(label4)
		@table_header.addSubview(label5)
		@table_header.addSubview(label6)
		@table_header.addSubview(label7)
		@table_header.addSubview(label)

		label0 = nil
		label1 = nil
		label2 = nil 
		label3 = nil
		label4 = nil
		label5 = nil
		label6 = nil 
		label7 = nil 
		label = nil

		@so_num_group = create_textfield_group(@so_num_label, @so_number, viewController, true)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "so_num_group" => @so_num_group,  "table_header" => @table_header, "detail_data" => @detail_data, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) - 20)
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_num_group(==height)]-margin-[table_header(==30)]-[detail_data(==450)]-(>=10)-|"
			layout.horizontal "|-left_margin-[so_num_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[table_header]-10-|"
			layout.horizontal "|-left_margin-[detail_data]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end	


		APIRequest.new.get('ship_lines', {so_number: @so_number.text, user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site}) do |result|
			viewController.view.nextResponder.stopSpinner

			if result["success"]
				position = 0
				result["result"].each do |data|
					new_view = UIView.new
		  		new_view.frame = [[0,position],[600,50]]

					label1 = UILabel.alloc.initWithFrame([[0,5],[30,30]])
					label1.adjustsFontSizeToFitWidth = true
					label1.textAlignment = UITextAlignmentCenter
					label1.text = "#{data["ttline"]}"

					label2 = UILabel.alloc.initWithFrame([[50,5],[70,30]])
					label2.adjustsFontSizeToFitWidth = true
					label2.textAlignment = UITextAlignmentCenter
					label2.text = "#{data["ttitem"]}"

					label3 = UILabel.alloc.initWithFrame([[130,5],[40,30]])
					label3.adjustsFontSizeToFitWidth = true
					label3.textAlignment = UITextAlignmentCenter
					label3.text = "#{data["ttqtyord"].to_i}"

					label4 = UILabel.alloc.initWithFrame([[180,5],[40,30]])
					label4.adjustsFontSizeToFitWidth = true
					label4.textAlignment = UITextAlignmentCenter
					label4.text = "#{data["ttqtyshipd"].to_i}"

					label5 = UILabel.alloc.initWithFrame([[230,5],[40,30]])
					label5.adjustsFontSizeToFitWidth = true
					label5.textAlignment = UITextAlignmentCenter
					label5.text = "#{data["ttqtytoship"].to_i}"

					label6 = UILabel.alloc.initWithFrame([[280,5],[60,30]])
					label6.adjustsFontSizeToFitWidth = true
					label6.textAlignment = UITextAlignmentCenter
					label6.text = "#{data["ttqtyscan"].to_i}"

					# label6 = UISwitch.alloc.initWithFrame([[280,5],[60,30]])
					# label6.addTarget(self, action: 'flagBO', forControlEvents: UIControlEventValueChanged)

					label7 = createTextField
					addSharedAttributes(label7, "Qty")
					label7.frame = [[350,5], [50,30]]
					label7.layer.borderWidth= 0.0

					label8 = createTextField
					addSharedAttributes(label8, "Location")
					label8.frame = [[410,5], [70,30]]
					label8.layer.borderWidth= 0.0

					label9 = createTextField
					addSharedAttributes(label9, "Tag/Ref")
					label9.frame = [[490,5], [70,30]]
					label9.layer.borderWidth= 0.0
					label9.delegate = self

					new_view.addSubview(label1)
					new_view.addSubview(label2)
					new_view.addSubview(label3)
					new_view.addSubview(label4)
					new_view.addSubview(label5)
					new_view.addSubview(label6)
					new_view.addSubview(label7)
					new_view.addSubview(label8)
					new_view.addSubview(label9)

		  		@detail_data.addSubview(new_view)

		  		position += 50
					label1 = nil
					label2 = nil
					label3 = nil
					label4 = nil
					label5 = nil
					label6 = nil
					label7 = nil
					label8 = nil
					label9 = nil
					new_view = nil
				end


				@detail_data.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)
				@table_header = nil
			else
				p result
				App.alert result["result"]
				buildSKD1(viewController, current_text)
			end
		end
	end

	def buildBKF(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.navigationItem.rightBarButtonItem.enabled = true
		@item_num.becomeFirstResponder
		@item_num.userInteractionEnabled = true
		@qty_label.text = "Qty"

		@item_num_group = create_textfield_group(@item_num_label, @item_num, viewController)
		@qty_group = create_textfield_group(@qty_label, @qty, viewController)
		@prod_line_group = create_textfield_group(@prod_line_label, @prod_line, viewController)
		@user_initials = create_textfield_group(@user_initials_label, @user_initials, viewController)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num_group" => @item_num_group, "qty_group" => @qty_group, "prod_line_group" => @prod_line_group, "user_initials" => @user_initials, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20, "long_half_width" => ((viewController.view.frame.size.width - 410) / 2)
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[item_num_group(==height)][qty_group(==height)]-margin-[prod_line_group(==height)][user_initials(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[item_num_group(==half_width)]-[qty_group(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[prod_line_group(==half_width)][user_initials(==half_width)]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
	end

	def buildVMI(viewController, tag_numbers)
		@nextBtn.enabled = false
		position = 0

		@tag_view_area.subviews.each { |subview| subview.removeFromSuperview }

		tag_numbers.each do |tag_value|
			longGesture = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handleTapGestures:')

			parentView = UIView.new
			parentView.frame = [[100,position],[self.view.frame.size.width - 400,50]]
			parentView.tag = tag_value['tttag'].to_i

			label = UILabel.alloc.initWithFrame([[100, 0],[self.view.frame.size.width - 400,50]])
			label.numberOfLines = 1
			label.text = "#{tag_value['tttag']}"

			breakline = UILabel.new
			breakline.backgroundColor = UIColor.blackColor
			breakline.frame = [[-100,50], [self.view.frame.size.width - 400,2]]

			parentView.addSubview(label)
			parentView.addSubview(breakline)
			parentView.addGestureRecognizer(longGesture)

			@tag_view_area.addSubview(parentView)

			position += 50
		end
		@hidden_tag_num.becomeFirstResponder
		@tag_view_area.contentSize = CGSizeMake(self.view.frame.size.width - 440, position + 50)

	end

	def sharedLayoutParameters(layout, *params)
		layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
		layout.horizontal "|-0-[alert_area(==400)]-0-|"
		layout.horizontal "|-0-[table(==400)]-[header]-10-|"
		unless params.empty?
			#layout.horizontal "|-#{params[0][:left_margin]}-[submit]-10-|"
		 	layout.horizontal "|-#{params[0][:left_margin]}-[header]-10-|"
		end
	end

	def createTable(view)
		table = UITableView.new
		table.dataSource = view
		table.delegate = view
		table
	end

	def createTextField
		textField = UITextField.new
		textField.clearButtonMode = UITextFieldViewModeWhileEditing
    textField.layer.masksToBounds= true
    textField.layer.borderColor= UIColor.colorWithRed(0.29, green: 0.58, blue: 0.53, alpha: 0.3).CGColor
    textField.layer.borderWidth= 1.0
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
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		@skid_num.text = ""
		@remarks.text = ""
		@lot.text = ""
		@current_qty.text = ""
		@current_item.text = ""
		@po_number.text = ""
		@new_pallet = false
		@data_container = nil
	end

	def flagBO
		p "B/O"
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
			if @header.text.downcase.match(/por/)
				@text_area.text = "Transaction Successful: \n #{@header.text} \n"
			else
				@text_area.text = "Transaction Successful: \n #{@header.text} \n Item Num: \t #{@item_num.text}\nQty: \t #{@qty.text}\nFrom Loc: \t #{@from_loc.text}\nTo Loc: \t #{@to_loc.text}"
			end
			clearTextFields
		elsif update_type == "update"
			tag_area = @text_area.text.split("\n").delete_if { |tag| tag == " " }
			tag_area.delete_at(0) if tag_area.count >= 8

			@text_area.text = "#{tag_area.join("\n").strip} \n #{message}"
		else
			@text_area.text = "Transaction Failed: \n #{message}"
		end

		unless update_type == "update"
			NSTimer.scheduledTimerWithTimeInterval(5.0, target:self, selector: "clearAlertArea", userInfo: nil, repeats: false)
		end
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

	def addCarton(gesture)
		@skid_num.resignFirstResponder
		if @cartons.include?(gesture.view.subviews[0].text)
			@cartons.delete gesture.view.subviews[0].text
			gesture.view.backgroundColor = UIColor.clearColor
		else
			gesture.view.backgroundColor = UIColor.colorWithRed(0.48, green: 0.70, blue: 0.56, alpha: 0.8)
			@cartons << gesture.view.subviews[0].text
		end
	end

	def create_textfield_group(label, field, viewController, full_width=false)
		full_width = full_width ? ((viewController.view.frame.size.width - 410) / 2) : ((viewController.view.frame.size.width - 410) / 4)
		group = createView
		label.frame = [[0,0], [full_width,50]]
		field.frame = [[full_width,0], [full_width - 20, 50]]
		group.addSubview(label)
		group.addSubview(field)
		return group
	end

	def handleLongPressGestures(sender)
		sender.view.subviews[3].text = sender.view.subviews[5].text.match(/\d+/)[0]
		sender.view.subviews[2].becomeFirstResponder
	end

	def handleTapGestures(sender)
		processTagScan(sender.view)
	end

	def processSHP(so, line, effective_date, cancel_bo, ship_qty , location, tag, shipped_label, open_label)
		shipped_label.superview.superview.superview.nextResponder.showSpinner

		effective_date = effective_date.empty? ? Time.now.strftime('%m/%d/%y') : effective_date
		cancel_bo = cancel_bo ? "yes" : "no"
		APIRequest.new.get('shp', {string: "#{so},#{line},#{effective_date},#{cancel_bo},#{ship_qty},#{location},#{tag},", user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
	  	tag_scanned = shipped_label.superview.subviews[8].text
	  	if result["success"]
	  		shipped_label.text = (shipped_label.text.to_i + ship_qty.to_i).to_s
	  		open_label.text = (open_label.text.to_i - ship_qty.to_i).to_s

	  		updateAlertArea("update", "#{tag_scanned} - Good Tag" )
	  		shipped_label.superview.subviews[6].text = ''
	  		shipped_label.superview.subviews[7].text = ''
	  		shipped_label.superview.subviews[8].text = ''
	  	else
	  		updateAlertArea("update", "#{tag_scanned} - #{result["result"]}" )
	  		App.alert(result["result"].to_s)
	  	end
	  	
	  	shipped_label.superview.superview.superview.nextResponder.stopSpinner


	  end
	end

	def processTagScan(workingView)
		remainingTags = @tag_view_area.subviews.count
		unless workingView.nil?
			if workingView.subviews.count == 2
				success = UIImageView.alloc.initWithFrame([[0,0], [50, 50]])
				success.image = UIImage.imageNamed("green_check.png")
				workingView.addSubview(success)

				@tag_view_area.subviews.map do |detailView|
					remainingTags -= 1 if detailView.subviews.count == 3
				end
			else
				App.alert("Tag has already been scanned.")
			end
		end

		if remainingTags == 0
			APIRequest.new.post('submit_vmi_tag', {distribution_num: @distribution_num.text, user: UIApplication.sharedApplication.delegate.username.downcase, action: 'pick'}) do |result|
				if result[:success] == "Good"
					App.alert("Order successfully placed.")
				else
					App.alert("Error! #{result[:error]}")
				end
				@tag_view_area.subviews.each { |subview| subview.removeFromSuperview }
				@nextBtn.enabled = true
				@distribution_num.text = ''
				@distribution_num.becomeFirstResponder	
			end
		end
	end

	def textField(textField, shouldChangeCharactersInRange: range, replacementString: replacement)
		if textField == @remarks
			unless textField.text.length < 13
				App.alert("Cannot use more then 20 characters.")
				textField.text = textField.text[0..13]
			end
		end
		textField
	end

	def textFieldDidBeginEditing(textField)

	end
	
	def textFieldDidEndEditing(textfield)
		if textfield === @tag_num || textfield === @new_tag_num
			if textfield.text.empty? || @new_pallet
				@to_loc.userInteractionEnabled = true
			else
				APIRequest.new.get('tag_details', {tag: textfield.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
					if result["success"] == true 
						if @header.text.match(/PLO/).nil?
							@from_loc.text = result["result"]["ttloc"]
						else
							@to_loc.text = result["result"]["ttloc"]
						end

						if @header.text.match(/PUL/) != nil || @header.text.match(/PDL/) != nil
							APIRequest.new.get('item_location', {item_num: result["result"]["ttitem"], user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
								default_location = result["Location"]
								@to_loc.text = default_location
							end
						end

						@item_num.userInteractionEnabled = false
						@item_num.text = result["result"]["ttitem"]
						@from_site.text = result["result"]["ttsite"]
						@to_site.text = result["result"]["ttsite"]
						@current_qty.text = "Current tag qty: #{result["result"]["ttqtyloc"].to_i}"
						@current_item.text = "#{result["result"]["ttdesc1"]}"

						@to_loc.userInteractionEnabled = true

						APIRequest.new.get('item_location', {item_num: @item_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
					  	default_location = result["Location"]

					  	if @new_pallet
				  			@to_loc.userInteractionEnabled = true
	  						@from_loc.userInteractionEnabled = true
	  					else
	  						unless @header.text.match(/PLO/).nil?
		  						@to_loc.userInteractionEnabled = false 
		  						@from_loc.userInteractionEnabled = true
		  					end
	  					end
				  		@from_loc.text = default_location unless @from_loc.text != ""
					  end
					else
						@to_loc.userInteractionEnabled = true
					end
				end	
			end
		elsif textfield === @item_num
			if @header.text.match(/^\w+\s+/)[0].strip.downcase == "bkf"
				@prod_lines = []

				APIRequest.new.get('bkf_product_lines', {site: UIApplication.sharedApplication.delegate.site, part: @item_num.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
					if result['ProdLines'].empty?
						App.alert 'There are no product lines associated to this item.'
					else
						@prod_lines = result['ProdLines'].split(',')
						@prod_line_picker = UIPickerView.new
						@prod_line_picker.frame = CGRectMake(20, 100, 260, 120)
						@prod_line_picker.delegate = self
						@prod_line_picker.dataSource = self
						@prod_line.inputView = @prod_line_picker
					end
					# textfield.superview.superview.nextResponder.stopSpinner unless textfield.superview.nil?
				end
			else
			  APIRequest.new.get('item_location', {item_num: @item_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			  	default_location = result["Location"]
  
			  	if @header.text.match(/PLO/).nil?
			  		@from_loc.text = default_location
			  	else
			  		if @new_pallet
			  			@to_loc.userInteractionEnabled = true
  						@from_loc.userInteractionEnabled = true
  					else
  						@from_loc.userInteractionEnabled = true
  					end
			  		# @from_loc.text = default_location
			  	end
			  end
			end
		elsif textfield === @carton_item
			APIRequest.new.get('carton_box_validation', {box: textfield.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				if result["status"] == "Box Good"
				else
					App.alert(result["error"])
					textfield.text = ""
				end
			end
		elsif textfield === @skid_num && @header.text.match(/^\w+\s+/)[0].strip.downcase == "skd"
			unless @skid_num.text.empty?
				APIRequest.new.get('skid_exist', {user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, skid: @skid_num.text}) do |result|
				  p result
				end
			end
		else
			APIRequest.new.get('get_tag_info', {site: UIApplication.sharedApplication.delegate.site, tag: textfield.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				if result["success"] == "good"
				else
				end
			end
		end
		textfield
	end

	def textFieldShouldReturn(textfield)
		if  @header.text.match(/^\w+\s+/)[0].strip.downcase == "shp"
			effective_date = Time.now.strftime("%m/%d/%y")
			APIRequest.new.get('get_tag_info', {tag: textfield.text, user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site.downcase}) do |result|
				current_view = textfield.superview.subviews
				if result["success"].downcase == "good"
					current_view[6].text = result["INFO"].first["ttqtyloc"].to_i.to_s
					current_view[7].text = result["INFO"].first["ttloc"]
					processSHP(@so_number.text, current_view[0].text, effective_date, "no", current_view[6].text, current_view[7].text, textfield.text, current_view[5], current_view[4])
				else
		  		updateAlertArea("update", "#{current_view[8].text} - #{result["INFO"].first["ttitem"]}" )
					App.alert(result["INFO"].first["ttitem"])
				end
			end
		elsif @header.text.match(/^\w+\s+/)[0].strip.downcase == "vmi"
			workingView = @tag_view_area.viewWithTag(textfield.text.to_i)
			processTagScan(workingView)
			textfield.text = ''
		end
	end

	def pickerView(pickerView, numberOfRowsInComponent: componenent)
		if pickerView == @prod_line_picker
			@prod_lines.count
		else
			@por_loc.count
		end
	end

	def pickerView(pickerView, titleForRow: row, forComponent: componenent)
		if pickerView == @prod_line_picker
			@prod_lines[row]
		else
			@por_loc[row]
		end
	end

	def numberOfComponentsInPickerView(pickerView)
		1
	end

	def pickerView(pickerView, didSelectRow: row, inComponent: componenent)
		if pickerView == @prod_line_picker
			@prod_line.text = @prod_lines[row]
			@prod_line.resignFirstResponder
		else
			@data_container.subviews.each do |subview|
				subview.subviews.each do |subview|
					if subview.isFirstResponder
						subview.text = @por_loc[row] 
						subview.resignFirstResponder
					end
				end if subview.class == UIView
			end 
		end
	end
end