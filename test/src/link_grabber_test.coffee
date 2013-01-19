describe 'LinkGrabber', ->
	
	describe 'with html input', ->
		
		it 'should find all links', ->
			links = LinkGrabber.fromHTMLString('<p>Lorem <a href="http://foo/">ipsum</a> dolor <a href="http://bar/">lorem</a> ipsum</p>').allLinks()
			links.should.have.lengthOf(2)
			links[0].should.equal("http://foo/")
			links[1].should.equal("http://bar/")
		
		it 'should ignore anchor name tags', ->
			links = LinkGrabber.fromHTMLString('<a name="top">foo</a> http://bar/').allLinks()
			links.should.have.lengthOf(1)
			links[0].should.equal("http://bar/")
		
		it 'should ignore mailto links', ->
			links = LinkGrabber.fromHTMLString('<a href="mailto:foo@bar.com">mail</a> http://bar/').allLinks()
			links.should.have.lengthOf(1)
			links[0].should.equal("http://bar/")
		
		it 'should ignore javascript links', ->
			links = LinkGrabber.fromHTMLString('<a href="javascript:console.log(\'foo\')">javascript</a> http://bar/').allLinks()
			links.should.have.lengthOf(1)
			links[0].should.equal("http://bar/")
		
		it 'should ignore duplicate urls', ->
			links = LinkGrabber.fromHTMLString('<a href="http://foo/"></a> <a href="http://foo/"></a>').allLinks()
			links.should.have.lengthOf(1)
		
		it 'should find plain urls', ->
			links = LinkGrabber.fromHTMLString('<b>http://www.google.com</b>').allLinks()
			links.should.have.lengthOf(1)
			links[0].should.equal("http://www.google.com")
		
		it 'should find html and plain urls without duplicates', ->
			links = LinkGrabber.fromHTMLString('<a href="http://foo/">test1</a> http://foo/ <a href="http://bar/">test2</a>').allLinks()
			links.should.have.lengthOf(2)
			links[0].should.equal("http://foo/")
			links[1].should.equal("http://bar/")