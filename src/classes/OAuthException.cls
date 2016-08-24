public class OAuthException extends Exception {
   
    public OAuthException withMessage(String message){
        setMessage(message);
        return this;
    }
    public OAuthException causedBy(Exception ex){
        this.initCause(ex);
        return this;
    }
    public static OAuthException create(){
        return new OAuthException().withMessage('OAuth error');
    }
}