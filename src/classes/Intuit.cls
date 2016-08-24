public class Intuit {
    
    //public enum EntityStatus {Deleted,Voided,Draft, Pending,InTransit, [Synchronized], SyncError}
    /*
    public class IntuitResponse {
        
        private List<Warning> warnings;
        private List<Object> items;
        private String requestId;
        private Datetime timeField;
        private String status;
    
        public List<Warning> getWarnings()  {
            return this.warnings;
        }
        public void setWarnings(List<Warning> value) {
            this.warnings = value;
        }
        public List<Object> getItems() {
            return this.items;
        }
        public void setItems(List<Object> value) {
            this.items = value;
        }
        public String getrequestId() {
            return this.requestId;
        }
        public void setrequestId(String value) {
            this.requestId = value;
        }
        public Datetime getTime() {
            return this.timeField;
        }
        public void setTime(Datetime value) {
            this.timeField = value;
        }
        public String getStatus() {
            return this.status;
        }
        public void setStatus(String value) {
            this.status = value;
        }
    }
    
    
    abstract class IntuitEntity {
        
        private String id;
        private String syncToken;
        //private ModificationMetaData metaData;
        //private List<CustomField> customFieldField;
        //private List<AttachableRef> attachableRefField;
        private String domain;
        //private EntityStatus status;
        private String status;
        private Boolean sparse;
        
        public String getId() {
            return this.id;
        }
        public void setId(String value) {
            this.id = value;
        }
        
        public String getSyncToken() {
            return this.syncToken;
        }
        public void setSyncToken(String value) {
            this.syncToken = value;
        }*/
        //public ModificationMetaData getMetaData() {
        //    return this.metaData;
        //}
        //public void setMetaData(ModificationMetaData value) {
        //    this.metaData = value;
        //}
        //public List<CustomField> getCustomField() {
        //    return this.customField;
        //}
        //public void setCustomField(List<CustomField> value) {
        //    this.customField = value;
        //}
        //public List<AttachableRef> getAttachableRef() {
        //    return this.attachableRef;
        //}
       // public void setAttachableRef(List<AttachableRef> value) {
        //    this.attachableRef = value;
        //}
        
    /*
    public String getDomain() {
            return this.domain;
        }
        public void setDomain(String value) {
            this.domain = value;
        }
        //public EntityStatus getstatus() {
        public String getstatus() {
            return this.status;
        }
        //public void setStatus(EntityStatus value) {
        public void setStatus(String value) {
            this.status = value;
        }
        public Boolean getSparse() {
            return this.sparse;
        }
        public void setSparse(Boolean value) {
            this.sparse = value;
        }
       
    }

	public class Warning {
        
        private String message;
        private String detail;
        private String code;
        private String element;
    
        public String getMessage() {
            return this.message;
        }
        public void setMessage(String value) {
            this.message = value;
        }
    
        public String getDetail() {
            return this.detail;
        }
        public void setDetail(String value) {
            this.detail = value;
        }
        public String getCode() {
            return this.code;
        }
        public void setCode(String value) {
            this.code = value;
        }
        public String getElement(){
            return this.element;
        }
        public void setElement(String value) {
            this.element = value;
        }
    }
    public class NameValue {
        
        private String name;
        private String value;

        public String getName() {
            return this.name;
        }
        public void setName(String value) {
            this.name = value;
        }
        public String getValue() {
            return this.value;
        }
        public void setValue(String value) {
            this.value = value;
        }
    }
    public class ReferenceType {
        
        private String name;
        private String type;
        private String value;

        public String getName() {
            return this.name;
        }
        public void setName(String value) {
            this.name = value;
        }
        public String getType() {
            return this.type;
        }
        public void setType(String value) {
            this.type = value;
        }
        public String getValue() {
            return this.value;
        }
        public void setValue(String value) {
            this.value = value;
        }
    }

    public class ModificationMetaData {
    
        private ReferenceType createdByRef;
        private Datetime createTime;
        private ReferenceType lastModifiedByRef;
        private Datetime lastUpdatedTime;
        private Datetime lastChangedInQb;
        private Boolean isSynchronized;
        
        public ReferenceType getCreatedByRef() {
            if (createdByRef==null){
                 createdByRef = new ReferenceType();
            }
            return this.createdByRef;
        }
        public void setCreatedByRef(ReferenceType value) {
            this.createdByRef = value;
        }
        public Datetime getCreateTime() {
            return this.createTime;
        }
        public void setCreateTime( Datetime value) {
            this.createTime = value;
        }
        public ReferenceType getLastModifiedByRef() {
            if (lastModifiedByRef==null){
                 lastModifiedByRef = new ReferenceType();
            }
            return this.lastModifiedByRef;
        }
        public void setLastModifiedByRef(ReferenceType value) {
            this.lastModifiedByRef = value;
        }
        public Datetime getLastUpdatedTime() {
            return this.lastUpdatedTime;
        }
        public void setLastUpdatedTime(Datetime value) {
            this.lastUpdatedTime = value;
        }
        public Datetime getLastChangedInQb() {
            return this.lastChangedInQb;
        }
        public void setLastChangedInQB(Datetime value) {
            this.lastChangedInQB = value;
        }
        public Boolean getSynchronized() {
            return this.isSynchronized;
        }
        public void setSynchronized(Boolean value) {
            this.isSynchronized = value;
        }
    }


    public class QueryResponse {
        private List<Warning> warnings;
        private List<Object> items;
        private Integer startPosition;
        private Integer maxResults;
        private Integer totalCount;
        
        public List<Warning> getWarnings() {
            return this.warnings;
        }
        public void setWarnings(List<Warning> value) {
            this.warnings = value;
        }
        public List<Object> getItems() {
            return this.items;
        }
        public void setItems(List<Object> value) {
            this.items = value;
        }
        public Integer getStartPosition() {
            return this.startPosition;
        }
        public void setStartPosition(Integer value) {
            this.startPosition = value;
        }
        public Integer getMaxResults() {
            return this.maxResults;
        }
        public void setMaxResults(Integer value) {
            this.maxResults = value;
        }
        public Integer getTotalCount() {
            return this.totalCount;
        }
        public void setTotalCount(Integer value) {
            this.totalCount = value;
        }
    }
*/
}