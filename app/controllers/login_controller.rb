class LoginController < UIViewController

	def viewDidLoad
		self.title = 'Login'
		self.view.backgroundColor = UIColor.whiteColor
		@picker_data = ["","2000", "3000", "4300"]
		@printers = ["","Biz363", 'It-Printer', '3600it']


		@builder = ScreenBuilder.alloc.initWithView(self)
		@builder.initUIPickerView(self)
		@builder.buildLogIn(self)
		@printer = @builder.printer
		@site_num = @builder.site_num
		@username = @builder.username
		@password = @builder.password
		super
	end

	def login
		if Validator.textfields_complete?([@username, @password, @site_num, @printer])
			APIRequest.new.get("login", {username: @username.text, password: @password.text, site_num: @site_num.text, printer: @printer.text}) do |result|
				if result["success"] == true
					UIApplication.sharedApplication.delegate.username = @username.text
					UIApplication.sharedApplication.delegate.printer = @printer.text
					UIApplication.sharedApplication.delegate.site = @site_num.text

					self.navigationController.pushViewController(MainMenuController.alloc.initWithNibName(nil, bundle:nil), animated: true)
				else
					App.alert("#{result["result"]}")
				end
			end
		else
			App.alert("All Fields must be completed before logging in.")
		end
		
	end

	#Delegate methods
	def pickerView(pickerView, numberOfRowsInComponent: componenent)
		if @printer.isFirstResponder
			@printers.count
		elsif @site_num.isFirstResponder
			@picker_data.count
		end
	end

	def pickerView(pickerView, titleForRow: row, forComponent: componenent)
		if @printer.isFirstResponder
			@printers[row]
		elsif @site_num.isFirstResponder
			@picker_data[row]
		end
	end

	def numberOfComponentsInPickerView(pickerView)
		1
	end

	def pickerView(pickerView, didSelectRow: row, inComponent: componenent)
		if @printer.isFirstResponder
			@printer.text = "#{@printers[row]}"
			@printer.resignFirstResponder
		elsif @site_num.isFirstResponder
			@site_num.text = "#{@picker_data[row]}"
			@site_num.resignFirstResponder
		end
		
	end
end