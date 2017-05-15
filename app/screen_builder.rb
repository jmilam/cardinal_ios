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
	attr_reader :po_number
	attr_reader :po_items
	attr_reader :label_count
	attr_reader :so_number
	attr_reader :carton_item
	attr_reader :carton_number
	attr_reader :cartons

	def initWithView(view)
		@cartons = Array.new
		@new_pallet = false
		@table = createTable(view)
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
		addSharedAttributes(@site_num, 'Site Num')

		@printer = createTextField
		addSharedAttributes(@printer, 'Printer')

		@login = UIButton.buttonWithType(UIButtonTypeRoundedRect)
		@login.setTitle('Login', forState:UIControlStateNormal)
		@login.setTitle('Logging In..', forState:UIControlStateSelected)
		@login.addTarget(viewController, action: 'login', forControlEvents:UIControlEventTouchUpInside)


		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "username" => @username, "password" => @password, "site_num" => @site_num, "printer" => @printer, "login" => @login
			layout.metrics "margin" => 10, "height" => 50
			layout.vertical "|-75-[username(==height)]-margin-[password(==height)]-margin-[site_num(==height)]-margin-[printer(==height)]-margin-[login(==height)]-(>=15)-|"
			layout.horizontal "|-(>=100)-[username(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[password(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[site_num(==300)]-(>=100)-|"
			layout.horizontal "|-(>=100)-[printer(==300)]-(>=100)-|"
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
		addSharedAttributes(@tag_num, 'Enter Existing Tag Number')
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
		addSharedAttributes(@remarks, 'Enter Label Wording...')
		@remarks.delegate = self

		@skid_num = createTextField
		addSharedAttributes(@skid_num, 'Skid Number')
		@skid_num.delegate = self

		@po_number = createTextField
		addSharedAttributes(@po_number, "Enter PO Number...")

		@label_count = createTextField
		addSharedAttributes(@label_count, "How many labels?")

		@so_number = createTextField
		addSharedAttributes(@so_number, "Enter Sales Order Number...")

		@carton_item = createTextField
		addSharedAttributes(@carton_item, "Enter Box Carton Item #")
		@carton_item.delegate = self

		@carton_number = createTextField
		addSharedAttributes(@carton_number, "Enter Carton #")

		@ship_to = createTextField
		addSharedAttributes(@ship_to, "Ship To...")

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
				layout.subviews "table" => @table, "header" => @header, "carton_number" => @carton_number, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[carton_number(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[carton_number]-10-|"
			end
		elsif @header.text.downcase.match(/plo/).nil?
			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[tag_num]-10-|"
			end
		
		else
			Motion::Layout.new do |layout|
				layout.view viewController.view
				layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "new_button" => @new_button, "alert_area" => @alert_area
				layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
				layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
				layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][new_button(==height)]-(>=10)-|"
				layout.horizontal "|-0-[alert_area(==400)]-0-|"
				layout.horizontal "|-0-[table(==400)]-[header]-10-|"
				layout.horizontal "|-left_margin-[header]-10-|"
				layout.horizontal "|-left_margin-[tag_num(==half_width)][new_button(==half_width)]-10-|"

			end
		end
	end

	def buildPCT(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.text = current_text
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "qty" => @qty, "current_qty" => @current_qty, "current_item" => @current_item, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20, "left_padding" => (((viewController.view.frame.size.width - 410) / 2)) + 410
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num(==height)][item_num(==height)]-margin-[qty(==height)][current_item(==height)]-margin-[current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[qty(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_padding-[current_qty(==half_width)]-10-|"

			sharedLayoutParameters(layout, {left_margin: 410})
			
		end

		viewController
	end

	def buildPDL(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.becomeFirstResponder
		@from_loc.userInteractionEnabled = false
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "current_qty" => @current_qty, "current_item" => @current_item, "from_loc" => @from_loc, "to_loc" => @to_loc, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][item_num(==height)]-margin-[from_loc(==height)][current_item(==height)]-margin-[to_loc(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[to_loc(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildPLO(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.becomeFirstResponder
		@qty.placeholder = "Qty"
		@from_site.text = UIApplication.sharedApplication.delegate.site
		@to_site.text = UIApplication.sharedApplication.delegate.site
		@to_loc.userInteractionEnabled = false
		enableItemNumField
		@item_num.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "current_qty" => @current_qty, "current_item" => @current_item, "qty" => @qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "from_site" => @from_site, "to_site" => @to_site, "new_button" => @new_button, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==height)]-margin-[tag_num(==height)][new_button(==height)]-margin-[item_num(==height)][qty(==height)]-margin-[from_site(==height)][to_site(==height)]-margin-[from_loc(==height)][to_loc(==height)]-margin-[current_item(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[new_button(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[item_num(==half_width)]-[qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_site(==half_width)]-[to_site(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildPMV(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "tag_num" => @tag_num, "to_loc" => @to_loc, "from_loc" => @from_loc, "current_qty" => @current_qty, "current_item" => @current_item, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][current_item(==height)]-margin-[to_loc(==height)][item_num(==height)]-margin-[from_loc(==height)][current_qty(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[current_item(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[to_loc(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[current_qty(==half_width)]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
			
		end

		viewController
	end

	def buildPUL(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.becomeFirstResponder
		disableItemNumField

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "item_num" => @item_num, "current_qty" => @current_qty, "tag_num" => @tag_num, "qty" => @qty,"current_item" => @current_item, "current_qty" => @current_qty, "from_loc" => @from_loc, "to_loc" => @to_loc, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)][item_num(==height)]-margin-[from_loc(==height)][to_loc(==height)]-margin-[qty(==height)][current_qty(==height)]-margin-[current_item(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num(==half_width)]-[item_num(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[from_loc(==half_width)]-[to_loc(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[qty(==half_width)]-[current_qty(==half_width)]-10-|"
			layout.horizontal "|-left_margin-[current_item]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end

		viewController
	end

	def buildTPT(viewController, current_text)
		@tag_num.userInteractionEnabled = true
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@tag_num.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "tag_num" => @tag_num, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[tag_num(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[tag_num]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildGLB(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@remarks.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "remarks" => @remarks, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[remarks(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[remarks]-10-|"
			sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildPOR1(viewController, current_text)
 	 	viewController.navigationItem.rightBarButtonItem = @nextBtn

		@po_number.becomeFirstResponder

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "po_number" => @po_number, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[po_number(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[po_number]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
			#sharedLayoutParameters(layout, {left_margin: 410})
		end
	end

	def buildPOR2(viewController, data_hash)
		viewController.navigationItem.rightBarButtonItem = @submitBtn

		@data_container = UIScrollView.new
		breakline = UILabel.new
		breakline.backgroundColor = UIColor.blackColor

		@por_loc = ["INSPECT", "C-ROCK", "UPFLOOR"]
		@locations = UIPickerView.new
		@locations.frame = CGRectMake(20, 100, 260, 120)
		@locations.delegate = self
		@locations.dataSource = self

		position = 0
		data_hash[:po_items].each do |data|
			new_view = UIView.new
			new_view.frame = [[0,position],[600,100]]
			label1 = UILabel.alloc.initWithFrame([[0,0],[200,30]])
			label2 = createTextField
			addSharedAttributes(label2, "Qty receiving?")
			label2.frame = [[400,0],[200,30]]
			label2.layer.borderWidth= 0.0
			label3 = UILabel.alloc.initWithFrame([[0, 40], [200,20]])
			label4 = UILabel.alloc.initWithFrame([[400,40],[200,30]])
			label5 = createTextField
			addSharedAttributes(label5, "Location..")
			label5.frame = [[225,0], [150,30]]
			label5.layer.borderWidth= 0.0
			label5.inputView = @locations
			#breakline.frame = [[0,80], [600,1]]

			label1.text = data["ttitem"]
			label3.text = "Line # " + data["ttline"].to_s
			label4.text = data["ttqtyopen"].to_i.to_s + " To Be Received"
			new_view.addSubview(label1)
			new_view.addSubview(label2)
			new_view.addSubview(label3)
			new_view.addSubview(label4)
			new_view.addSubview(label5)
			#new_view.addSubview(breakline)
			@data_container.addSubview(new_view)
			position += 100
			label1 = nil
			label2 = nil
			label3 = nil
			label4 = nil
			label5 = nil
			new_view = nil
		end

		@data_container.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)

		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header,"data_container" => @data_container, "label_count" => @label_count, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[data_container(==200)]-margin-[label_count(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[data_container]-10-|"
			layout.horizontal "|-left_margin-[label_count]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
		end
	end

	def buildCAR(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.view.nextResponder.showSpinner

		@carton_item.becomeFirstResponder

		@data_container = UIScrollView.new
		@table_header = UIView.new
		@table_header.backgroundColor = UIColor.grayColor

		label = UILabel.alloc.initWithFrame([[20,0],[50,30]])
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
			layout.subviews "table" => @table, "header" => @header, "so_number" => @so_number, "carton_item" => @carton_item, "table_header" => @table_header, "data_container" => @data_container, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[so_number(==height)]-margin-[carton_item(==height)]-margin-[table_header(==30)]-[data_container(==450)]-(>=10)-|"
			layout.horizontal "|-left_margin-[so_number]-10-|"
			layout.horizontal "|-left_margin-[carton_item]-10-|"
			layout.horizontal "|-left_margin-[table_header]-10-|"
			layout.horizontal "|-left_margin-[data_container]-10-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
		end
		@table_header = nil

		APIRequest.new.get('sales_order_details', {so_number: @so_number.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
			breakline = UILabel.new
			breakline.backgroundColor = UIColor.blackColor
			 if result["status"] == "Good"
			  	position = 0
			  	result["Lines"].each do |line|
			  		new_view = UIView.new
			  		new_view.frame = [[0,position],[600,50]]

		    		label1 = UILabel.alloc.initWithFrame([[0,0],[20,30]])
						label1.adjustsFontSizeToFitWidth = true
						label1.textAlignment = UITextAlignmentCenter

						label2 = createTextField
						addSharedAttributes(label2, "Qty")
						label2.frame = [[20,0], [50,30]]
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

			  		label1.text = "#{line["ttli"]}"
			  		label3.text = "#{line["ttqtyord"]}"
						label4.text = "#{line["ttqtyshp"]}"
						label5.text = "#{line["ttcarton"]}"
						label6.text = "#{line["ttskid"]}"
						label7.text = "#{line["ttlength"]}"
						label8.text = "#{line["ttdesc"]}"
						label9.text = "#{line["ttqtypck"]}"

			   		new_view.addSubview(label1)
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

				@data_container.contentSize = CGSizeMake(self.view.frame.size.width - 440, position)
			end
			viewController.view.nextResponder.stopSpinner
		end	
	end

	def buildSKD1(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @nextBtn
		@so_number.becomeFirstResponder
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "sales_order" => @so_number, "skid_num" => @skid_num, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[sales_order(==height)]-margin-[skid_num(==height)]-(>=10)-|"
			layout.horizontal "|-0-[alert_area(==400)]-0-|"
			layout.horizontal "|-0-[table(==400)]-[header]-10-|"
			layout.horizontal "|-left_margin-[header]-10-|"
			layout.horizontal "|-left_margin-[sales_order]-10-|"
			layout.horizontal "|-left_margin-[skid_num]-10-|"

		end
	end

	def buildSKD2(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		viewController.view.nextResponder.showSpinner

		@detail_data = UIScrollView.new

		APIRequest.new.get('skid_create_cartons', {sales_order: @so_number.text, site: UIApplication.sharedApplication.delegate.site.downcase, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
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
					layout.subviews "table" => @table, "header" => @header, "sales_order" => @so_number, "skid_num" => @skid_num, "detail_data" => @detail_data, "alert_area" => @alert_area
					layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
					layout.vertical "|-#{@nav_bar_height}-[table(>=500)]-[alert_area]-0-|"
					layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[sales_order(==height)]-margin-[skid_num(==height)]-margin-[detail_data(==500)]-(>=10)-|"
					layout.horizontal "|-0-[alert_area(==400)]-0-|"
					layout.horizontal "|-0-[table(==400)]-[header]-10-|"
					layout.horizontal "|-left_margin-[header]-10-|"
					layout.horizontal "|-left_margin-[sales_order]-10-|"
					layout.horizontal "|-left_margin-[skid_num]-10-|"
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

	def buildSkidLabel(viewController, current_text)
		viewController.navigationItem.rightBarButtonItem = @submitBtn
		@skid_num.becomeFirstResponder
		Motion::Layout.new do |layout|
			layout.view viewController.view
			layout.subviews "table" => @table, "header" => @header, "skid_num" => @skid_num, "alert_area" => @alert_area
			layout.metrics "margin" => 10, "height" => 50, "left_margin" => 410, "half_width" => ((viewController.view.frame.size.width - 410) / 2) - 20
			layout.vertical "|-#{@nav_bar_height}-[header(==50)]-margin-[skid_num(==height)]-(>=10)-|"
			layout.horizontal "|-left_margin-[skid_num]-10-|"
			sharedLayoutParameters(layout)
		end
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
			clearTextFields
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
		if textfield === @tag_num
			if @tag_num.text.empty? || @new_pallet
				@to_loc.userInteractionEnabled = true
			else
				textfield.superview.nextResponder.showSpinner
				APIRequest.new.get('tag_details', {tag: @tag_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
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
			textfield.superview.nextResponder.showSpinner
			APIRequest.new.get('item_location', {item_num: @item_num.text, user_id: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				default_location = result["Location"]

				if @header.text.match(/PLO/).nil?
					@from_loc.text = default_location
				else
					if @tag_num.text.empty? || @new_pallet
						@to_loc.userInteractionEnabled = true
						end

					@from_loc.text = default_location
				end
				textfield.superview.nextResponder.stopSpinner
			end
		elsif textfield === @carton_item
			#validate valid box carton. If not alert invalid box
			APIRequest.new.get('carton_box_validation', {box: textfield.text, user: UIApplication.sharedApplication.delegate.username.downcase}) do |result|
				if result["status"] == "Box Good"
				else
					App.alert(result["error"])
					textfield.text = ""
					textfield.becomeFirstResponder
				end
			end
		elsif textfield === @skid_num && @header.text.match(/^\w+\s+/)[0].strip.downcase == "skd"
			unless @skid_num.text.empty?
				APIRequest.new.get('skid_exist', {user: UIApplication.sharedApplication.delegate.username.downcase, site: UIApplication.sharedApplication.delegate.site, skid: @skid_num.text}) do |result|
				  p result
				end
			end
		end #unless @item_num.text.empty?
		textfield
	end

	def pickerView(pickerView, numberOfRowsInComponent: componenent)
		3
	end

	def pickerView(pickerView, titleForRow: row, forComponent: componenent)
		@por_loc[row]
	end

	def numberOfComponentsInPickerView(pickerView)
		1
	end

	def pickerView(pickerView, didSelectRow: row, inComponent: componenent)
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