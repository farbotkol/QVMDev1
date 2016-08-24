@isTest
class UriBuilderTests {

    static UriBuilderTestFixture test(){
        return new UriBuilderTestFixture();
    }
   
    @isTest
    static void schemeIsNormalized()
    {
         test().usingInput('http://host.com/').isAbsolute().portIs(0).schemeIs('http').withValue('http://host.com/');
         test().usingInput('HTTP://host.com/').schemeIs('http').withValue('http://host.com/');
			
         test().usingInput('HTTP://host.com').schemeIs('http').withValue('http://host.com/');
        
        //runNewTest('http://host:90/');
        //runNewTest('http://host:90/path/?a=123');
    }

     @isTest
    static void authorityIsNormalizedHttp()
    {
         test().usingInput('http://host.com/')
         .isAbsolute()
         .portIs(0)
         .schemeIs('http')
         .withValue('http://host.com/');

         test().usingInput('http://HoSt.Com:80/')
            .isAbsolute()
            .portIs(80)
            .schemeIs('http')
            .withValue('http://host.com/');

         test().usingInput('http://HoSt.Com:8080/')
            .isAbsolute()
            .portIs(8080)
            .schemeIs('http')
            .withValue('http://host.com:8080/');
    }
    @isTest
    static void authorityIsNormalizedHttps()
    {
         test().usingInput('https://host.com/')
             .isAbsolute()
             .portIs(0)
             .schemeIs('https')
             .withValue('https://host.com/');

         test().usingInput('https://HoSt.Com:443/')
            .isAbsolute()
            .portIs(443)
            .schemeIs('https')
            .withValue('https://host.com/');

         test().usingInput('https://HoSt.Com:8443/')
            .isAbsolute()
            .portIs(8443)
            .schemeIs('https')
            .withValue('https://host.com:8443/');
    }
    @isTest
    static void authorityIsNormalizedNoScheme()
    {
         test().usingInput('//host.com/')
             .isNotAbsolute()
             .portIs(0)
             .schemeIs('')
             .withValue('//host.com/');

         test().usingInput('//HoSt.Com:99/')
            .isNotAbsolute()
            .portIs(99)
            .schemeIs('')
            .withValue('//host.com:99/');
    }

    @isTest 
    static void absoluteWithPathQueryAndFragment(){
        test().usingInput('http://sample.com/one/two/?q=v&q2=v2#my_anchor')
            .pathIs('/one/two/')
            .isAbsolute()
            .queryIs('q=v&q2=v2')
            .fragmentIs('my_anchor')
            .withValue('http://sample.com/one/two/?q=v&q2=v2#my_anchor');
    }

    @isTest 
    static void absoluteWithPathAndFragment(){
        //this one also has a slightly different path..
        test().usingInput('http://sample.com/one/two#my_anchor')
            .pathIs('/one/two')
            .queryIs('')
            .isAbsolute()
            .fragmentIs('my_anchor')
            .withValue('http://sample.com/one/two#my_anchor');
    }
    @isTest 
    static void absoluteWithQuery(){
        //this one also has a slightly different path..
        test().usingInput('http://sample.com/?q=v&q2=v2')
            .pathIs('/')
            .queryIs('q=v&q2=v2')
            .isAbsolute()
            .fragmentIs('')
            .withValue('http://sample.com/?q=v&q2=v2');
    }
    @isTest
    static void authorityWithUser()
    {
         test().usingInput('ftp://cnn.example.com&story=breaking_news@10.0.0.1:88/my_page.html')
             .isAbsolute()
             .portIs(88)
             .schemeIs('ftp')
             .hostIs('10.0.0.1')
             .userInfoIs('cnn.example.com&story=breaking_news')
             .withValue('ftp://cnn.example.com&story=breaking_news@10.0.0.1:88/my_page.html');

    }

    @isTest
    static void authorityIsNormalizedFtp()
    {
         test().usingInput('ftp://host.com/')
             .isAbsolute()
             .portIs(0)
             .schemeIs('ftp')
             .withValue('ftp://host.com/');

         test().usingInput('ftp://HoSt.Com:21/')
            .isAbsolute()
            .portIs(21)
            .schemeIs('ftp')
            .withValue('ftp://host.com/');

         test().usingInput('ftp://HoSt.Com:88/')
            .isAbsolute()
            .portIs(88)
            .schemeIs('ftp')
            .withValue('ftp://host.com:88/');
    }
   
    @isTest
    static void relativeOnlyPath()
    {
        test().usingInput('some/path')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('some/path')
            .fragmentIs('')
            .queryIs('')
            .withValue('some/path');
    }
    @isTest
    static void relativePathQueryFragment()
    {
        test().usingInput('/?q=n&x=y#something')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('/')
            .queryIs('q=n&x=y')
            .fragmentIs('something')
            .withValue('/?q=n&x=y#something');

         test().usingInput('one/Two?q=n&#something')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('one/Two')
            .queryIs('q=n&')
            .fragmentIs('something')
            .withValue('one/Two?q=n&#something');            
    }
    @isTest
    static void partiallyEncodedQuery(){
        test().usingInput('/query?query=Select * from Customer')
            .queryIs('query=Select%20*%20from%20Customer')
            .withValue('/query?query=Select%20*%20from%20Customer');
    }
    
    @isTest
    static void relativePathFragment()
    {
        test().usingInput('/#something')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('/')
            .queryIs('')
            .fragmentIs('something')
            .withValue('/#something');

         test().usingInput('one#something')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('one')
            .queryIs('')
            .fragmentIs('something')
            .withValue('one#something');
    }

    @isTest
    static void relativeOnlyQuery()
    {
        test().usingInput('?q=n&x=y')
            .hasRelativeUrlSchemeAndAuthority()
            .pathIs('')
            .queryIs('q=n&x=y')
            .fragmentIs('')
            .withValue('?q=n&x=y');
    }
     @isTest
    static void relativeOnlyFragment()
    {
        test().usingInput('#page_anchor')
            .hasRelativeUrlSchemeAndAuthority()
            .fragmentIs('page_anchor')
            .pathIs('')
            .queryIs('')
            .withValue('#page_anchor');
    }
    @isTest
    static void leftPartAbsolute(){
        Test().usingInput('http://test.google.com/some/resource?s=abc#details')
            .leftPartIs(UriBuilder.UriComponent.Scheme,'http:')
            .leftPartIs(UriBuilder.UriComponent.Authority, 'http://test.google.com')
            .leftPartIs(UriBuilder.UriComponent.Path, 'http://test.google.com/some/resource')
            .leftPartIs(UriBuilder.UriComponent.Query, 'http://test.google.com/some/resource?s=abc')
            .leftPartIs(UriBuilder.UriComponent.Fragment, 'http://test.google.com/some/resource?s=abc#details');
    }
    @isTest static void combineConstructor()
    {
        Test().usingInput('https://cs31.salesforce.com', '/apex/mypage')
            .hostIs('cs31.salesforce.com')
            .pathIs('apex/mypage');
    }
}