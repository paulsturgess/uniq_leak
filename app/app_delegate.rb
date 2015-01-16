class MyController < UIViewController
  def viewDidLoad
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle('Start', forState:UIControlStateNormal)
    button.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventTouchUpInside)
    button.frame = [[100, 260], [view.frame.size.width - 200, 40]]
    view.addSubview(button)
  end

  def actionTapped
    10000.times do
      ["foo", "foo", "bar"].uniq # this causes a leak
      # ["foo", "bar"].uniq # this does not cause a leak
      # I actually found this bug by calling .uniq on an array of NSManagedObjects
    end
  end
end

class MyClass < NSManagedObject

end


class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = MyController.alloc.init
    rootViewController.title = 'uniq_leak'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    true
  end
end
