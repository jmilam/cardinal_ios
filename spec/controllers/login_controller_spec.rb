describe "Login Functions" do
	tests LoginController

  before do
    @username = "jmilam"
    @password = "jm1010"
    @site = "2000"
    @printer = "ltp"

    fill_in_textfields
  end

  def fill_in_textfields
    counter = 0

    controller.view.subviews.each do |subview| 
      if subview.class == UIView
        case counter
        when 1
          subview.subviews[1].text = @username
        when 2
          subview.subviews[1].text = @password
        when 3
          subview.subviews[1].text = @site
        when 4
          subview.subviews[1].text = @printer
        end
      end
      counter += 1
    end
  end

  it "should fill in necessary login fields" do
    controller.view.subviews[1].subviews[1].text.should.equal "jmilam"
    controller.view.subviews[2].subviews[1].text.should.equal "jm1010"
    controller.view.subviews[3].subviews[1].text.should.equal "2000"
  	controller.view.subviews[4].subviews[1].text.should.equal "ltp"
  end

  it "should login successfully" do
    tap 'Login'

    controller.view.login

    wait_till 10 { @ip == false}
  end
end