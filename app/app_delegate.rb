class AppDelegate
	attr_accessor :username
  attr_accessor :printer
  attr_accessor :site
	attr_accessor :api_request_result
  attr_accessor :user_roles

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

  	@username = nil
    @printer = nil
    rootViewController = LoginController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    
  end
end
