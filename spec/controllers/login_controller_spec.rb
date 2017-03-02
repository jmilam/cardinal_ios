describe "Login Functions" do
	tests LoginController

	before do
		p controller
	end

  it "has four textfields and a button" do
  	controller.subviews.should.eq 5
  end
end