package stx.fail;

/**
  Represents information about an error. `uuid` is intended to be unique, but this iss currently not enforced.
**/
class Digest implements DigestApi{
  static public var register(get,null) : haxe.ds.StringMap<Digest>;
  static function get_register(){
    return register == null ? register = new haxe.ds.StringMap() : register;
  } 
  public final uuid    : String;
  public final detail  : String;
  public final code    : Int;

  public function new(uuid,detail,code=-1){
    this.uuid   = uuid;
    this.detail = detail;
    this.code   = code;
    
    if(register.exists(uuid)){
      final val         = register.get(uuid);
      final identifier  = std.Type.getClassName(std.Type.getClass(this));
      if(Type.getClass(val) != Type.getClass(this)){
        throw 'Digest identifier $uuid on ${identifier} already registered for $val';
      }
    }else{
      register.set(uuid,this);
    }
  }
  public function toString(){
    return '($code,"$uuid","$detail")';
  }
  public function asDigest():Digest{
    return this;
  }
  @:noUsing static public function Foreign(detail:String){
    return new DigestForeign(detail);
  }
}
private class DigestForeign extends Digest{
  public function new(detail,code=-1){
    super("125cb1ae06784bb586e87ea8f57cdb6e",detail,code);
  }
}