package stx.fail;

enum DeclineSum<E>{
  EXTERIOR(v:E);
  INTERIOR(digest:Digest);
}
@:using(stx.fail.Decline.DeclineLift)
abstract Decline<T>(DeclineSum<T>) from DeclineSum<T> to DeclineSum<T>{
  static public var _(default,never) = DeclineLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<T>(self:DeclineSum<T>):Decline<T> return new Decline(self);

  @:from static public function fromDigest<T>(code:Digest):Decline<T>{
    return INTERIOR(code);
  }
  static public function fromErrOf<T>(v:T):Decline<T>{
    return EXTERIOR(v);
  }
  public function prj():Decline<T> return this;
  private var self(get,never):Decline<T>;
  private function get_self():Decline<T> return lift(this);
}
class DeclineLift{
  static public function fold<T,Z>(self:DeclineSum<T>,val:T->Z,def:Digest->Z):Z{
    return switch(self){
      case EXTERIOR(v)    :  val(v);
      case INTERIOR(e)    :  def(e);
    }
  }
  static public function fold_filter<T>(self:DeclineSum<T>,val:T->Bool,def:Digest->Bool):Option<Decline<T>>{
    return fold(
      self,
      (x) -> if(val(x)){
        Some(EXTERIOR(x));
      }else{
        None;
      },
      x -> if(def(x)){
        Some(INTERIOR(x));
      }else{
        None;
      }
    );
  }
  static  public function value<T>(self:DeclineSum<T>):Option<T>{
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
        x -> EXTERIOR(fn(x)),
        y -> INTERIOR(y)      
      )
    );
  }
}