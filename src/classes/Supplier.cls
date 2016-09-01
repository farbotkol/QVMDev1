public class Supplier {
	public class BillAddr {
		public String Id;
		public String Line1;
		public String City;
		public String Country;
		public String CountrySubDivisionCode;
		public String PostalCode;
	}
    
    public class ShipAddr {
		public String Id;
		public String Line1;
		public String City;
		public String Country;
		public String CountrySubDivisionCode;
		public String PostalCode;
	}

	public class CurrencyRef {
		public String value;
		public String name;
	}

	public BillAddr BillAddr;
    public ShipAddr ShipAddr;
	public String TaxIdentifier;
	public TermRef TermRef;
	public Double Balance;
	public String AcctNum;
	public Boolean Vendor1099;
	public CurrencyRef CurrencyRef;
	public String domain;
	public Boolean sparse;
	public String Id;
	public String SyncToken;
	public MetaData MetaData;
	public String Title;
	public String GivenName;
	public String MiddleName;
	public String FamilyName;
	public String Suffix;
	public String CompanyName;
	public String DisplayName;
	public String PrintOnCheckName;
	public Boolean Active;
	public PrimaryPhone PrimaryPhone;
	public PrimaryPhone AlternatePhone;
	public PrimaryPhone Mobile;
	public PrimaryPhone Fax;
	public PrimaryEmailAddr PrimaryEmailAddr;
	public WebAddr WebAddr;

	public class PrimaryPhone {
		public String FreeFormNumber;
	}

	public class MetaData {
		public String CreateTime;
		public String LastUpdatedTime;
	}

	public class TermRef {
		public String value;
	}

	public class PrimaryEmailAddr {
		public String Address;
	}

	public class WebAddr {
		public String URI;
	}

	
	public static Supplier parse(String json) {
		return (Supplier) System.JSON.deserialize(json, Supplier.class);
	}
}