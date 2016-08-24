//list of name value pairs, unlike a Map it allows diplicate keys
//and can be sorted
public class HttpParameterList implements iterable<HttpParameter> {
    private final List<HttpParameter> items;

   
    public HttpParameterList(iterable<HttpParameter> source){
        this();
        add(source);
    }
    
    public HttpParameter get(Integer index){
        return items.get(index);
    }
    private class MergedListIterator implements Iterator<HttpParameter>
    {
        Iterator<Iterable<HttpParameter>> sources;
        Set<String> keysWithValues;
        HttpParameter nextValue;
        ITerator< HttpParameter> currentSource;
        
        public MergedListIterator(List<Iterable<HttpParameter>> sources){
            this.sources = sources.iterator();
            this.keysWithValues = new Set<String>();
            if (this.sources.hasNext()){
                 currentSource = this.sources.next().iterator();
            }
        }
        public Boolean hasNext(){
            if (currentSource==null){
                nextValue = null;
                return false;
            }
            do {
                while (!currentSource.hasNext()){
                    
                    if (!sources.hasNext()){
                        currentSource = null;
                        nextValue = null;
                        return false;
                    }
                    currentSource = sources.next().iterator();
                }
                nextValue = currentSource.next();
                
            } while(String.isEmpty(nextValue.name) || keysWithValues.contains(nextValue.name));
            keysWithValues.add(nextValue.name);
            return true;
            
        }
        public HttpParameter next(){
            return nextValue;
        }
    }
    private class MergedList implements Iterable<HttpParameter> {
        private final List<Iterable<HttpParameter>> sources;
        public MergedList(Iterable<HttpParameter> source, Iterable<HttpParameter> defaultValues){
            sources = new  List<Iterable<HttpParameter>>{source, defaultValues};
        }
        public Iterator<HttpParameter> iterator(){
            return new MergedListIterator(sources);
        }
    }
    public Integer size(){
        return items.size();
    }
    public HttpParameterList(Map<String, String> source){
        this();
        if (source!=null) {
            for(String name: source.keySet())
            {
                add(name, source.get(name));
            }
        }
    }
    public void insertAt(Integer index, HttpParameter item){
        if (item==null){
            throw ArgumentNullException.create('item');
        }
        items.add(index, item);
    }
    public HttpParameterList(){
        items = new List<HttpParameter>();
    }
    public Iterator<HttpParameter> iterator()
    {
        return items.iterator();
    }
    public Iterable<HttpParameter> mergeWith(Iterable<HttpParameter> defaultValues){
        return new MergedList(items, defaultValues);
    }
    public void sort()
    {
        items.sort();
    }
    
    public void addFrom(String values, HttpParameterFormat format){
        if (format==null){
            throw ArgumentNullException.create('format');
        }
        if (string.isNotEmpty(values)) {
            Iterator<HttpParameter> it = format.getValueReader(values);
            while(it.hasNext()){
                items.add(it.next());
            }
        } 
    }
    public void addFromQueryString(String queryString){
        addFrom(queryString, HttpParameterFormat.Url);
            
    }
    public String toString(HttpParameterFormat format){
        if (format==null){
            throw ArgumentNullException.create('format');
        }
        return format.join(this);
    }
    
    public override String toString(){
        return toString(HttpParameterFormat.FormUrl);
    }

    public void clear() {
        items.clear();
    }
        
   public void add(iterator<HttpParameter> it){
        if (it==null){return;}

        while(it.hasNext()) {
            items.add(it.next());
        }
        
    }
    public Integer indexOf(String name){
        Integer lastIndex = items.size()-1;

        for(Integer index=0;index<=lastIndex;index++){
            if (name==items[index].name){
                return index;
            }
        }
        return -1;
    }
    //reads a value from the list and removes the item at the same time
    //if the item does not exist then 
    public HttpParameter extractByName(String name){
        Integer itemIndex = indexOf(name);
        if (itemIndex<0){

            throw new ListException(MessageFormat.format('Parameter {0} not found',name),null);
        }
        HttpParameter retVal= items[itemIndex];
        items.remove(itemIndex);
        return retVal;
    }
    public void removeAt(Integer index){
        items.remove(index);
    }
    public void add(iterable<HttpParameter> source){
        if (source!=null){
            add(source.iterator());
            
        }
    }
    public void add(String name, String value) {
        items.add(new HttpParameter(name,value));
    }
    public void setValue(String name, String value){
        Integer index = indexOf(name);
        if (index>=0){
            if ( items[index].value != value){
            	items[index] = new HttpParameter(name, value);
            }
        } else {
            add(name, value);
        }
        
    }
    public String getValue(String name){
        Integer index = indexOf(name);
        if (index>=0){
            return items[index].value;
        }
        return null;
    }
    //removes all items with the provided name
    public void remove(String name){
        Integer index = items.size()-1;
        while(index>=0) {
            if (name==items[index].name) {
                items.remove(index);
            }
            index--;
        }
    }        
    
}