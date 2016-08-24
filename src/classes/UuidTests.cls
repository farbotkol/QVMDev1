@isTest
class UuidTests {
	@isTest
	static void simpleTests() {
		Uuid testValue = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Assert.areEqual('{F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4}', testValue.toString());
	}
	@isTest
	static void toStringD() {
		Uuid testValue = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Assert.areEqual('F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4', testValue.toString('D'));
		Assert.areEqual('F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4', testValue.toString('d'));
	}
	@isTest
	static void toStringP() {
		Uuid testValue = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Assert.areEqual('(F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4)', testValue.toString('P'));
		Assert.areEqual('(F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4)', testValue.toString('p'));
	}
	@isTest
	static void toStringB() {
		Uuid testValue = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Assert.areEqual('{F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4}', testValue.toString('b'));
		Assert.areEqual('{F9168C5E-CEB2-4FAA-B6BF-329BF39FA1E4}', testValue.toString('B'));
	}
	@isTest
	static void toStringN() {
		Uuid testValue = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Assert.areEqual('F9168C5ECEB24FAAB6BF329BF39FA1E4', testValue.toString('N'));
		Assert.areEqual('F9168C5ECEB24FAAB6BF329BF39FA1E4', testValue.toString('n'));
	}
	@isTest
	static void equalsTests() {
		Uuid value1 = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Uuid value2 = new Uuid('F9168C5E-CEB2-4faa-B6BF-329BF39FA1E4');
		Boolean equals = value1==value2;
		Assert.isTrue(equals);
	}
	@isTest
	static void newId() {
		Set<Uuid> values=new Set<Uuid>();

		for(Integer item=0;item<1000;item++){
			 if (!values.add(Uuid.newUuid()) )
			 {
			 	Assert.fail('found duplicate value');
			 }
		}
	}
}