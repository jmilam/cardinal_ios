describe "Login Functions" do
	tests LoginController

	before do
		@username = "jmilam"
		@password = "jm1010"
		@site = "2000"
		@printer = "3600it"
	end

  it "has seven textfields and a button" do
  	controller.view.subviews.each do |subview| 
  		counter = 0
  		if subview.class == UIView
  			case counter
  			when 1
  				subview.subviews[1].text = "jmilam"
  			when 2
  				subview.subviews[1].text = "jm1010"
  			when 3
  				subview.subviews[1].text = "2000"
  			when 4
  				subview.subviews[1].text = "3600it"
  			end

  			counter += 1
  		end
  	end

  	tap 'Login'
  	controller.view.subviews.count.should.equal 7
  end
end