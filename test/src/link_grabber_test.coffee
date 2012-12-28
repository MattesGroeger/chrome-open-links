describe 'LinkGrabber', ->
	
	describe 'with links', ->
		
		it 'should find all links', ->
			links = LinkGrabber.fromHTMLString('<p>Lorem <a href="http://foo/">ipsum</a> dolor <a href="http://bar/">lorem</a> ipsum</p>').allLinks()
			links.should.have.lengthOf(2)
			links[0].should.equal("http://foo/")
			links[1].should.equal("http://bar/")