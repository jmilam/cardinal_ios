class LoginController < UIViewController

	def viewDidLoad
		
		self.title = 'Welcome To Cardinal'
		self.view.backgroundColor = UIColor.whiteColor
		self.automaticallyAdjustsScrollViewInsets = false


		@builder = ScreenBuilder.alloc.initWithView(self)

		@builder.buildLogIn(self)

		@printer = @builder.printer
		@site_num = @builder.site_num
		@username = @builder.username
		@password = @builder.password
		super
	end

	def login
		if Validator.textfields_complete?([@username, @password, @site_num, @printer])
			showSpinner
			APIRequest.new.get("validate_printer", {user: @username.text, password: @password.text, site: @site_num.text, printer: @printer.text}) do |result|
				if result["success"]
					APIRequest.new.get("login", {username: @username.text, password: @password.text, site_num: @site_num.text, printer: @printer.text}) do |result|
						if result["success"] == true && result['site_valid']
							stopSpinner
							UIApplication.sharedApplication.delegate.username = @username.text
							UIApplication.sharedApplication.delegate.printer = @printer.text
							UIApplication.sharedApplication.delegate.site = @site_num.text
							UIApplication.sharedApplication.delegate.user_roles = result["user_roles"]

							self.navigationController.pushViewController(MainMenuController.alloc.initWithNibName(nil, bundle:nil), animated: true)
						else
							stopSpinner
							App.alert("#{result["result"]}")
						end
					end
				else
					stopSpinner
					App.alert("Printer is invalid. Please enter a valid printer.")
				end
			end
		else
			App.alert("All Fields must be completed before logging in.")
		end
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

end