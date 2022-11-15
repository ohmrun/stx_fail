package stx.fail;

enum DeclineSum<E>{
  EXTERNAL(v:E);
  INTERNAL(digest:Digest);
}
@:using(stx.fail.Decline.DeclineLift)
abstract Decline<T>(DeclineSum<T>) from DeclineSum<T> to DeclineSum<T>{
  static public var _(default,never) = DeclineLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<T>(self:DeclineSum<T>):Decline<T> return new Decline(self);

  @:from static public function fromDigest<T>(code:Digest):Decline<T>{
    return INTERNAL(code);
  }
  static public function fromErrOf<T>(v:T):Decline<T>{
    return EXTERNAL(v);
  }
  public function iterator(){
    return {
      next : () -> {
        return switch(this){
          case EXTERNAL(v) : v;
          default : null;
        }
      },
      hasNext : () -> {
        return switch(this){
          case EXTERNAL(v) : true;
          default          : false;
        }
      }
    }
  }
  public function prj():Decline<T> return this;
  private var self(get,never):Decline<T>;
  private function get_self():Decline<T> return lift(this);

}
class DeclineLift{
  static public function fold<T,Z>(self:DeclineSum<T>,val:T->Z,def:Digest->Z):Z{
    return switch(self){
      case EXTERNAL(v)    :  val(v);
      case INTERNAL(e)    :  def(e);
    }
  }
  static public function is_EXTERNAL<T,Z>(self:DeclineSum<T>){
    return fold(
      self,
      _ -> true,
      _ -> false
    );
  }
  static public function EXTERNAL<T,Z>(self:DeclineSum<T>){
    return fold(
      self,
      v -> Some(v),
      _ -> None
    );
  }
  static public function fold_filter<T>(self:DeclineSum<T>,val:T->Bool,def:Digest->Bool):Option<Decline<T>>{
    return fold(
      self,
      (x) -> if(val(x)){
        Some(EXTERNAL(x));
      }else{
        None;
      },
      x -> if(def(x)){
        Some(INTERNAL(x));
      }else{
        None;
      }
    );
  }
  static  public function option<T>(self:DeclineSum<T>):Option<T>{
    return fold(
      self,
      Some,
      (_) -> None
    );
  }
  static public function toString<T>(self:DeclineSum<T>):String{
    return fold(
      self,
      (v) -> Std.string(v),
      (n) -> n.toString()
    );
  }
  static public function map<E,EE>(self:DeclineSum<E>,fn:E->EE):Decline<EE>{
    return Decline.lift(
      fold(
        self,
        x -> EXTERNAL(fn(x)),
        y -> INTERNAL(y)      
      )
    );
  }
}