package stx.fail;

/**
 * Types of ways to decline handling a state. 
 * `INTERNAL` refers to states which are unhandleable and not intended to be caught except to report to the user/developer.
 *  Note `INTERNAL` errors are not really intended for inspection and thus do not have too many functions that apply to them.
 * 
 * `EXTERNAL` refers to subsystem states which may or may no be true errors, but are intended to signal some information to the program at some point.
 */
enum DeclineSum<E>{
  /**
   * Internal (FATAL) error
   */
  INTERNAL(digest:Digest);
  /**
   * Programmer defined error state of type `E`
   */
  EXTERNAL(v:E);
  /**
   * Contains a `stx.pico.Embed` that can be unpacked later so type constraints can be maintained where control is delegated to a subsystem.
   */
  SECRETED(v:Void->Void);
}
/**
 * @see https://github.com/ohmrun/docs/blob/main/projection.md
 */
@:stx.code.meta.projection
@:using(stx.fail.Decline.DeclineLift)
abstract Decline<T>(DeclineSum<T>) from DeclineSum<T> to DeclineSum<T>{
  static public var _(default,never) = DeclineLift;
  public function new(self) this = self;
  @:noUsing static public inline function lift<T>(self:DeclineSum<T>):Decline<T> return new Decline(self);

  /**
   * Make a `Decline` `INTERNAL` from a `Digest`
   * @param self 
   */
  @:from static public function fromDigest<T>(code:Digest):Decline<T>{
    return INTERNAL(code);
  }
  /**
   * Make a `Decline` `EXTERNAL` from any value
   * @param self 
   * @return Decline<T>
   */
  static public function fromErrOf<T>(v:T):Decline<T>{
    return EXTERNAL(v);
  }
  /**
   * Iterates only an `EXTERNAL` error.
   */
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
  /** 
   * @see docs/blob/projection/main/fold.md
   * @param self 
   * @return String
   */
  static public function fold<T,Z>(self:DeclineSum<T>,val:T->Z,def:Digest->Z,ext:(Void->Void)->Z):Z{
    return switch(self){
      case DeclineSum.EXTERNAL(v)    :  val(v);
      case DeclineSum.INTERNAL(e)    :  def(e);
      case DeclineSum.SECRETED(f)    :  ext(f);
    }
  }
  /**
   * Returns `true` if EnumValue is `EXTERNAL(t:T)`, false otherwise.
   * @param self 
   * @param fn 
   * @return Decline<EE>
   */
  static public function is_external<T,Z>(self:DeclineSum<T>){
    return fold(
      self,
      _ -> true,
      _ -> false,
      _ -> false
    );
  }
  /**
   * Returns `Option` of `EXTERNAL`
   * @param self 
   * @param fn 
   * @return Decline<EE>
   */
  static public function external<T,Z>(self:DeclineSum<T>){
    return fold(
      self,
      v -> Some(v),
      _ -> None,
      _ -> None
    );
  }
  /**
   * Allows filtering of value of either `INTERNAL` or `EXT
   * @param self 
   * @param fn 
   * @return Decline<EE>
   */
  static public function fold_filter<T>(self:DeclineSum<T>,val:T->Bool,def:Digest->Bool):Option<Decline<T>>{
    return fold(
      self,
      (x) -> if(val(x)){
        Some(DeclineSum.EXTERNAL(x));
      }else{
        None;
      },
      x -> if(def(x)){
        Some(INTERNAL(x));
      }else{
        None;
      },
      (_) -> None
    );
  }
  static  public function option<T>(self:DeclineSum<T>):Option<T>{
    return fold(
      self,
      Some,
      (_) -> None,
      (_) -> None
    );
  }
  static public function toString<T>(self:DeclineSum<T>):String{
    return fold(
      self,
      (v) -> Std.string(v),
      (n) -> n.toString(),
      (_) -> 'SECRETED ERROR'
    );
  }
  /**
   * Only operates on `EXTERNAL`. 
   * @see https://github.com/ohmrun/docs/blob/main/projection/map.md
   * @param self 
   * @param fn 
   * @return Decline<EE>
   */
  static public function map<E,EE>(self:DeclineSum<E>,fn:E->EE):Decline<EE>{
    return Decline.lift(
      fold(
        self,
        x -> DeclineSum.EXTERNAL(fn(x)),
        y -> DeclineSum.INTERNAL(y),      
        z -> DeclineSum.SECRETED(z)
      )
    );
  }
  static public function disembed<E,EE>(self:DeclineSum<E>,fn:Embed<EE>):Decline<EE>{
    return fold(
      self,
      e -> DeclineSum.INTERNAL(Digest.Secrete('Error not SECRETED, found instead ${e}')),
      y -> DeclineSum.INTERNAL(y),
      z -> fn.unpack(z).fold(
        ok -> DeclineSum.EXTERNAL(ok),
        () -> DeclineSum.INTERNAL(Digest.Secrete('Embed does not contain SECRETED value'))
      )
    );
  }
  static public function embed<E,EE>(self:DeclineSum<E>,fn:Embed<E>):Decline<EE>{
    return fold(
      self,
      e -> DeclineSum.SECRETED(fn.pack(e)),
      y -> DeclineSum.INTERNAL(y),
      z -> DeclineSum.INTERNAL(Digest.Secrete('Cannot embed a SECRETED error'))
    );
  }
}