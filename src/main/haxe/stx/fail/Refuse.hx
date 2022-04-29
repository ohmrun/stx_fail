package stx.fail;

import haxe.ds.Either;
/**
  Either an INTERIOR (unhandled) or EXTERIOR (E) Error
**/
typedef RefuseDef<E> = Error<Decline<E>>;

@:using(stx.fail.Refuse.RefuseLift)
@:forward abstract Refuse<E>(RefuseDef<E>) from RefuseDef<E> to RefuseDef<E>{
  static public var _(default,never) = RefuseLift;
  public function new(self) this = self;
  @:noUsing static public function lift<E>(self:RefuseDef<E>):Refuse<E> return new Refuse(self);
  static public function unit<E>():Refuse<E> return lift(new stx.fail.term.Unit());
  @:noUsing static public function make<E>(data:Option<Decline<E>>,next:Option<Error<Decline<E>>>,pos:Option<Pos>){
    return lift(new stx.fail.term.Base(data,next,pos));
  }
  @:noUsing static public function pure<E>(v:E){
    return make(Some(EXTERIOR(v)),None,None);
  }
  public function prj():RefuseDef<E> return this;
  private var self(get,never):Refuse<E>;
  private function get_self():Refuse<E> return lift(this);

  @:from static public function fromErrorApi<E>(self:ErrorApi<Decline<E>>){
    return lift(self);
  }
  public function errate<EE>(fn:E->EE):Refuse<EE>{
    return new stx.fail.term.MapAnon(this,Decline._.map.bind(_,fn)).toError();
  }
  static public function catcher(self:Error<Dynamic>):Either<Error<Dynamic>,Refuse<Dynamic>>{
    final _enum : Enum<Dynamic> = Type.getEnum(EXTERIOR(null));
    return switch(self.data){
      case Some(x) : switch(std.Type.typeof(x)){
        case TEnum(e) : switch(e){
          case x if (x == _enum) : 
            Right((Refuse.lift(cast self)));
          default :
            Left(self.elide());
        }
        default : Left(self.elide());
      }
      default : Left(self.elide());
    }
  }
  public function concat(that):Refuse<E>{
    return lift(this.concat(that));
  }
}
class RefuseLift{
  static public function usher<E,Z>(self:RefuseDef<E>,fn:Option<Decline<E>>->Z):Z{
    return fn(self.data);
  }
}