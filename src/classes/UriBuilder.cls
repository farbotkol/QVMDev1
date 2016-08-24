//builder and helper functions for working with URIs
public class UriBuilder {
	
	// this regular expression is taken from the URI specification 
	// https://tools.ietf.org/html/rfc3986#appendix-B
	// the unescaped version is   ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
	private static final Pattern patternUri = Pattern.compile('^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?');
	private static final Integer CHAR_PERIOD = '.'.charAt(0);
	private static final Integer CHAR_FORWARD_SLASH = '/'.charAt(0);
	private static final List<ComponentWriter> componentWriters = new List<ComponentWriter>{
		new SchemeWriter(), 
		new AuthorityWriter(), 
		new PathWriter(), 
		new QueryWriter(), 
		new FragmentWriter()};
	//component parts of a URL in order
	public enum UriComponent{Scheme, Authority, Path, Query, Fragment,All}

	private String scheme;
	private String userInfo;
	private String host;
	private Integer port;
	private String path;
	private String fragment;
	private String query;

	public UriBuilder(){
		//initialize with empty strings instead of null values
		setAuthorityInternal(null);
		setPathInternal(null);
		setFragmentInternal(null);
		setQueryInternal(null);
	}
	public UriBuilder(String uri){
		if (uri==null) {throw ArgumentNullException.create('uri');}
		if (!parse(uri)){
			throw ArgumentException.forArgument('uri');
		}
	}
    public UriBuilder(String baseUri, String relativeUri){
		this(baseUri, new UriBuilder(relativeUri));
	}
	public UriBuilder(String baseUri, UriBuilder relativeUri){
		if (baseUri==null) {throw ArgumentNullException.create('baseUri');}
		if (!parse(baseUri)){
			throw ArgumentException.forArgument('baseUri');
		}
		if (!setRelativeFromPath(relativeUri)){
			setRelativeFromQueryAndFragment(relativeUri);
		}
	}
	private void combineWith(UriBuilder relativeUri){
		if (relativeUri==null) {throw ArgumentNullException.create('relativeUri');}

		if (!isAbsoluteUri()){
			throw new InvalidOperationException('Cannot combine 2 relative URIs');
		}

		if (relativeUri.isAbsoluteUri()){
			throw ArgumentException.forArgument('relativeUri').withMessage('relativeUri may not be an absolute URI');
		}
		
		if (!setRelativeFromPath(relativeUri)){
			setRelativeFromQueryAndFragment(relativeUri);
		}
	}
	public UriBuilder(UriBuilder baseUri, UriBuilder relativeUri)
	{
		if (baseUri==null) {throw ArgumentNullException.create('baseUri');}
		cloneFrom(baseUri);
		combineWith(relativeUri);
		
	}
	private String resolvePathAbsolute(String relativePath){
		return relativePath;
		if (relativePath.length()>1 && relativePath.charAt(1)==CHAR_FORWARD_SLASH){
			throw new UnsupportedOperationException('Retative URIs that change the host are not supported');
		}
		return relativePath;
	}

	private String resolvePathRelative(String basePath, String relativePath){
		List<String> pathParts = basePath.split('/');
		System.debug('basePath is made up of '+pathParts.size()+' parts');
		for(Integer i = 0;i<pathParts.size();i++){
			System.debug('Item '+i+': '+pathParts[i]);
		}
		throw new InvalidOperationException('TODO: Not implemented');
	}
	private String combinePaths(String basePath, String relativePath){

		if (basePath.charAt(basePath.length()-1)==CHAR_FORWARD_SLASH){
			return basePath+relativePath;
		}
		return basePath.substringBeforeLast('/')+'/'+relativePath;
	}
	private Boolean setRelativeFromPath(UriBuilder other){
		String relativePath = other.path;
		if (String.isNotBlank(relativePath)){
			
			Integer firstCharacter= relativePath.charAt(0);
			if (firstCharacter==CHAR_FORWARD_SLASH){
				this.path = resolvePathAbsolute(relativePath);
			} else if (firstCharacter == CHAR_PERIOD) {
				this.path = resolvePathRelative(path, relativePath);
			} else {
				this.path = combinePaths(path, relativePath);
			}
			
			this.query = other.query;
			this.fragment = other.fragment;
		}
		return false;
	}

	private void setRelativeFromQueryAndFragment(UriBuilder other){
		if (String.isNotBlank(other.query)){
			this.query = other.query;
			this.fragment = other.fragment;

		} else if (String.isNotBlank(other.fragment)){
			this.fragment = other.fragment;
		}

	}
	
	private void cloneFrom(UriBuilder other){
		this.scheme = other.scheme;
		this.userInfo = other.userInfo;
		this.host = other.host;
		this.port = other.port;
		this.path = other.path;
		this.query = other.query;
		this.fragment = other.fragment;
	}

	public Boolean isAbsoluteUri(){
		return String.IsNotEmpty(host) && String.IsNotEmpty(scheme);
	}

	private Boolean parse(String uri){
		Matcher matcher = patternUri.matcher(uri);
		if (!matcher.matches()){
			return false;
		}
		
		// see  https://tools.ietf.org/html/rfc3986#appendix-B for details
		setSchemeInternal(matcher.group(2));
		setAuthorityInternal( matcher.group(4));
		setPathInternal(matcher.group(5));
		setQuery(matcher.group(7));
		setFragmentInternal(matcher.group(9));
		return true;
	}
	public String getScheme(){
		return scheme;
	}
	public String getHost(){
		return this.host;
	}
	public String getUserInfo(){
		return this.userInfo;
	}
	public void setUserInfo(string userInfo){
		this.userInfo = userInfo;
	}
	//set the scheme without doing a content validation
	private void setSchemeInternal(String scheme){
		if (String.isNotBlank(scheme)){
			this.scheme = scheme.toLowerCase();
		} else {
			this.scheme = '';
		}
	}
	private static String emptyWhenNull(String value){
		if (value==null){
			return '';
		}
		return value;
	}
	private void setFragmentInternal(String fragment){
		this.fragment = emptyWhenNull(fragment);
		
	}
	public String getPath(){
		return this.path;
	}
	public String getQuery(){
		return this.query;
	}
	public void setQuery(String query){
		if (String.isBlank(query)){
			this.query ='';
		}

		setQueryInternal(HttpParameterFormat.Url.normalize(query));
	}
	public void setQuery(Iterable<HttpParameter> parameters){
		
		setQueryInternal(HttpParameterFormat.Url.join(parameters));
		
	}
	public HttpParameterList getQueryAsParameters(){
		HttpParameterList retVal = new HttpParameterList();
		retVal.addFrom(this.query, HttpParameterFormat.Url);
		return retVal;
	}

	public String getFragment(){
		return this.fragment;
	}
	private void setQueryInternal(String query){
		this.query = emptyWhenNull(query);
	}
	private void setPathInternal(String path){
		this.path = emptyWhenNull(path);
	}
	private void setAuthorityInternal(String authority){
		if (String.isBlank(authority)){
			this.port=0;
			this.host='';
			this.userInfo='';
		} else{
			Integer positionHost = authority.indexOf('@');
			if (positionHost>=0){
				this.userInfo = authority.substring(0,positionHost);
				positionHost+=1;
			} else {
				positionHost=0;
			}
			Integer positionPort = authority.indexOf(':', positionHost);
			if (positionPort>=0){
				this.host = authority.substring(positionHost,positionPort);
				this.port =Integer.valueOf(authority.substring(positionPort+1));
			} else {
				this.host = authority.substring(positionHost);
				this.port =0;
			}
			//normalize as per rfc3986
			host = host.toLowerCase();
		}
	}

	public void setPort(Integer port){
		this.port = port;
	}
	public Integer getPort(){
		return this.port;
	}
	public void setHost(String host){
		this.host = emptyWhenNull(host);
	}
	public String getAuthority(){
		if (String.isEmpty(host))
		{
			return '';
		}
		string authority = host;
		if (!String.isEmpty(userInfo)){
			authority = userInfo+'@'+host;
		}
		if (!isPortDefaultForScheme())
		{
			authority +=':'+port;
		}
		return authority;

	}
	private Boolean isPortDefaultForScheme(){
		if (port==0 || port==null){
			return true;
		} 
		//no scheme but there is an explicit port so assume not default
		if (String.isBlank(scheme))
		{
			return false;
		}
		if (scheme=='http')
		{
			return port==80 ;
		}
		if (scheme=='https'  )
		{
			return port==443;
		}
		if (scheme=='ftp' ){
			return port==21;
		}
		//other schemes not implemented, assume as a port is specified that it is not the default
		return false;
	}
	//returns a string containing the parts of the URI
	//from the start up to and including the part specified
	//e.g. given http://test.google.com/some/resource?s=abc#details
	//    passing:  Component.Authority
	//    returns:  http://test.google.com/
	//   
	//    passing:  Component.Query
	//    returns:  http://test.google.com/some/resource?s=abc
    public String leftPart(UriComponent component){
    	String retVal='';
    	Integer stopAt=component.ordinal();

    	for(ComponentWriter writer:componentWriters){
    		if (writer.getOrdinal()>stopAt){
    			break;
    		}
    		retval = writer.appendTo(retval,this);
    	}
    	return retval;
    }
    private class SchemeWriter extends ComponentWriter
    {
    	public SchemeWriter(){
    		super(UriComponent.Scheme);
    	}
    	public override String appendTo(String value, UriBuilder builder)
    	{
    		String scheme = builder.scheme;
    		if (String.isNotBlank(scheme)){
    		 	value+=(scheme+':');
    		}
    		return value;
    	}
    }
    
	private class AuthorityWriter extends ComponentWriter
    {
    	public AuthorityWriter(){
    		super(UriComponent.Authority);
    	}
    	public override String appendTo(String value, UriBuilder builder)
    	{
    		String authority = builder.getAuthority();
    		if (String.isNotBlank(authority)){
    		 	value+=('//'+authority);
    		}
    		return value;
    	}
    }
	private class PathWriter extends ComponentWriter
    {
    	public PathWriter(){
    		super(UriComponent.Path);
    	}
    	public override String appendTo(String value, UriBuilder builder)
    	{
    		String path = builder.path;
    		if (String.isNotEmpty(path)){
    		 	value+=(path);
    		}
    		return value;
    	}
    }
    private class QueryWriter extends ComponentWriter
    {
    	public QueryWriter(){
    		super(UriComponent.Query);
    	}
    	public override String appendTo(String value, UriBuilder builder)
    	{
    		String query = builder.query;
    		if (String.isNotEmpty(query)){
    		 	value+=('?'+query);
    		}
    		return value;
    	}
    }
    private class FragmentWriter extends ComponentWriter
    {
    	public FragmentWriter(){
    		super(UriComponent.Fragment);
    	}
    	public override String appendTo(String value, UriBuilder builder)
    	{
    		String fragment = builder.fragment;
    		if (String.isNotEmpty(fragment)){
    		 	value+=('#'+fragment);
    		}
    		return value;
    	}
    }
    private abstract class ComponentWriter 
    {
    	private final UriComponent component;
    	private final Integer ordinal;

    	protected ComponentWriter(UriComponent component){
    		this.component =component;
    		this.ordinal =component.ordinal();
    	}
    	public Integer getOrdinal(){
    		return ordinal;
    	}
    	public abstract String appendTo(String value,UriBuilder builder);

    	public override string toString(){
    		return  component.name();
    	} 
    	
    }

    public PageReference toPageReference(){
    	return new PageReference(leftPart(UriComponent.All));
    }
	public override String toString(){
		
		return leftPart(UriComponent.All);

		
	}
}