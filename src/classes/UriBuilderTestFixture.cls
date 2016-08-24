//test ficture class with fluent style assertions
 public class UriBuilderTestFixture {
     private UriBuilder instance;
     private String currentTest;
     public UriBuilderTestFixture usingInput(string uri){
         this.instance = new UriBuilder(uri);
         currentTest =MessageFormat.format('input :{0}',Debug.describe(uri));
         return this;
     }
     public UriBuilderTestFixture usingInput(String baseUri, String relativeUri){
         this.instance = new UriBuilder(baseUri, relativeUri);
         currentTest = MessageFormat.format('input :{0}',Debug.describe(baseUri), Debug.describe(relativeUri));
         return this;
     }
     public UriBuilderTestFixture isAbsolute(){
         Assert.areEqual(true, instance.isAbsoluteUri(),'URI Should be absolute for '+currentTest);
         return this;
     }
     
     public UriBuilderTestFixture portIs(Integer portNumber){
         Assert.areEqual(portNumber, instance.getPort(),'Port incorrect for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture userInfoIs(String value){
         Assert.areEqual(value, instance.getUserInfo(),'User info incorrect for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture hasRelativeUrlSchemeAndAuthority(){
         isNotAbsolute();
         schemeIs('');
         userInfoIs('');
         hostIs('');
         portIs(0);
         return this;
     }
     public UriBuilderTestFixture hostIs(String value){
         Assert.areEqual(value, instance.getHost(),'Host incorrect for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture pathIs(String value){
         Assert.areEqual(value, instance.getPath(),'Host path for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture queryIs(String value){
         Assert.areEqual(value, instance.getQuery(),'Query incorrect for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture fragmentIs(String value){
         Assert.areEqual(value, instance.getFragment(),'fragment incorrect for '+currentTest);
         return this;
     }
     
     public UriBuilderTestFixture schemeIs(String scheme){
         Assert.areEqual(scheme, instance.getScheme(),'Scheme incorrect for '+currentTest);
         return this;
     }
     public UriBuilderTestFixture isNotAbsolute(){
         Assert.areEqual(false, instance.isAbsoluteUri(),'URI should not be absolute '+currentTest);
         return this;
     }
     public UriBuilderTestFixture withValue(String expected){
         Assert.areEqual(expected, instance.toString(),currentTest);
         return this;
     }
     
     public UriBuilderTestFixture leftPartIs(UriBuilder.UriComponent component, String expected){
         Assert.areEqual(expected, instance.leftPart(component),'Left part {0} {1}', component, currentTest);
         return this;
     }
 }