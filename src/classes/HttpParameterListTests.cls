@isTest
private class HttpParameterListTests {
	@isTest 
    static void newInstance()
    {
        HttpParameterList instance = new HttpParameterList();
        Assert.areEqual(0, instance.size());
    }
    
    @isTest
    static void newInstanceFromList()
    {
        List<HttpParameter> source = new List<HttpParameter>();
        source.add(new HttpParameter('item1','value1'));
        source.add(new HttpParameter('item2','value2'));
        HttpParameterList instance = new HttpParameterList(source);
        Assert.areEqual(2, instance.size());
    }
    @isTest
    static void newInstanceFrom()
    {
        HttpParameterList source = new HttpParameterList();
        source.add('name', 'value');
        Assert.areEqual(1, source.size());
        HttpParameterList instance = new HttpParameterList(source);
        Assert.areEqual(1, instance.size());
        Assert.areEqual('name', instance.get(0).name);
        Assert.areEqual('value', instance.get(0).value);
    }
        
    @isTest
    static void newInstanceFromMap()
    {
        Map<String,String> source = new Map<String,String>{ 'thing'=>'value'};
        HttpParameterList instance = new HttpParameterList(source);
        Assert.areEqual(1, instance.size());
        HttpParameter item = instance.get(0);
        Assert.areEqual(item.name, 'thing');
        Assert.areEqual(item.value, 'value');
    }
    
    @isTest
    static void sort() {
        HttpParameterList instance = new HttpParameterList();
        instance.add('before','value 1');
        instance.add('after','value 2');
        Assert.areEqual('before', instance.get(0).name);
        Assert.areEqual('after', instance.get(1).name);
        instance.sort();

        Assert.areEqual('after', instance.get(0).name);
        Assert.areEqual('before', instance.get(1).name);        
    }
    @isTest
    static void fromQueryString() {
        HttpParameterList instance = new HttpParameterList();
        instance.addFromQueryString('name=some%20value&other=%26another%20value');
        Assert.areEqual(2, instance.size());
        Assert.areEqual('name', instance.get(0).name);
        Assert.areEqual('some value', instance.get(0).value);
        Assert.areEqual('other', instance.get(1).name);
        Assert.areEqual('&another value', instance.get(1).value);
    }
}