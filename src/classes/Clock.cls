// clock implementation that allows for time based testing 
public class Clock {
	
	private static IProvider provider = new DefaultProvider();
	
	private interface IProvider {
		Datetime getNow();
	} 
	private class FrozenProvider implements IProvider {
		private final Datetime value;
		public FrozenProvider(Datetime value){
			this.value = value;
		}
		public Datetime getNow()
		{
			return value;
		}
	}
	private class DefaultProvider implements IProvider{
		
		public Datetime getNow()
		{
			return Datetime.now();
		}
	} 

	public static void freezeAt(Datetime value){
		provider = new FrozenProvider(value);
		Log.debug('Clock frozen at {0}', value);
	}

	public static void reset(){
		if (!(provider instanceof DefaultProvider))
		{
			provider = new DefaultProvider();
			Log.debug('Clock reset to normal time');
		}
	}
	public static Datetime now(){
		return provider.getNow();
	}
}