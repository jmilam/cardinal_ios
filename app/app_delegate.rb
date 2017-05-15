class AppDelegate
	attr_accessor :username
  attr_accessor :printer
  attr_accessor :site
	attr_accessor :api_request_result

  def application(application, didFinishLaunchingWithOptions:launchOptions)
  	@username = nil
    @printer = nil
    rootViewController = LoginController.alloc.init
    #rootViewController = MainMenuController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    
    return true if RUBYMOTION_ENV == 'test'
  end
end
