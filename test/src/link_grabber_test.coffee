describe 'LinkGrabber', ->
	
	describe 'with html input', ->
		
		it 'should find all links', ->
			links = LinkGrabber.fromHTMLString('<p>Lorem <a href="http://foo/">ipsum</a> dolor <a href="http://bar/">lorem</a> ipsum</p>').allLinks()
			links.should.have.lengthOf(2)
			links[0].should.equal("http://foo/")
			links[1].should.equal("http://bar/")
		
		it 'should ignore anchor name tags', ->
			links = LinkGrabber.fromHTMLString('<a name="top">foo</a>').allLinks()
			links.should.have.lengthOf(0)
		
		it 'should ignore duplicate urls', ->
			links = LinkGrabber.fromHTMLString('<a href="http://foo/"></a> <a href="http://foo/"></a>').allLinks()
			links.should.have.lengthOf(1)