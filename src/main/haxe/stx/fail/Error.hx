package stx.fail;

using stx.fail.Error;

function flat_map<Ti,Tii>(self:Option<Ti>,fn:Ti->Option<Tii>):Option<Tii>{
  return switch(self){
    case Some(n) : fn(n);
    default      : None;
  }
}
@:forward abstract Error<E>(ErrorApi<E>) from ErrorApi<E> to ErrorApi<E>{
  public function new(self) this = self;
  static public function lift<E>(self:ErrorApi<E>):Error<E> return new Error(self);
  @:noUsing static public function make<E>(data:Option<E>,next:Option<Error<E>>,pos:Option<Pos>){
    return lift(new stx.fail.term.Base(data,next,pos));
  }
  public function prj():ErrorApi<E> return this;
  private var self(get,never):Error<E>;
  private function get_self():Error<E> return lift(this);

  static public function Remote<E>(self:Iterator<E>,?pos:Pos):Refuse<E>{
    return new stx.fail.term.ErrorRemote(self,Some(pos)).toError();
  }
  static public function Unit<E>():Error<E>{
    return new stx.fail.term.Unit().toError();
  }
  public function map<EE>(fn:E->EE):Error<EE>{
    return new stx.fail.term.MapAnon(this,fn).toError();
  }
  public function errate<EE>(fn:E->EE):Error<EE>{
    return new stx.fail.term.MapAnon(this,fn).toError();
  }
  public function errata<EE>(fn:Error<E>->Error<EE>):Error<EE>{
    return new stx.fail.term.ErrataAnon(this,fn).toError();
  }
}
interface ErrorApi<E>{
  public var pos(get,null) : Option<Pos>;
  public function get_pos():Option<Pos>;

  public var stack(get,never):Option<CallStack>;
  public function get_stack():Option<CallStack>;

  public var next(get,null) : Option<ErrorApi<E>>;
  public function get_next():Option<ErrorApi<E>>;

  public var data(get,null) : Option<E>;
  public function get_data():Option<E>;

  public function toError():Error<E>;
  public function iterator():Iterator<Error<E>>;
  public function concat(that:Error<E>):Error<E>;

  public function toString():String;
  public function is_defined():Bool;
  public function raise():Void;
}
abstract class ErrorCls<E> implements ErrorApi<E>{

  public var pos(get,null):Option<Pos>;
  abstract public function get_pos():Option<Pos>;

  public var next(get,null):Option<Error<E>>;
  abstract public function get_next():Option<Error<E>>;

  public var data(get,null):Option<E>;
  abstract public function get_data():Option<E>;

  public var stack(get,never):Option<CallStack>;
  abstract public function get_stack():Option<CallStack>;

  public function toError():Error<E>{
    return this;
  }
  public function concat(that:Error<E>):Error<E>{
    return new stx.fail.term.ErrorConcat(Some(this.toError()),Some(that)).toError();
  }
  public function toString():String{
    return 'Error($data) at $pos\n${stack}';
  }
  final public function iterator(){
    var self : Option<Error<E>> = Some(this.toError());
    return {
      hasNext : () -> {
        return self != None;
      },
      next : () -> {
        var data = self;
        self = self.flat_map(x -> x.next);
        return switch(data){
          case Some(v)  : v;
          case None     : null;  
        }
      }
    }
  }
  public function raise():Void{
    switch(this.data){
      case Some(x) : throw(x);
      default      : throw 'ERROR'; 
    }
  }
  public function is_defined(){
    return switch(this.data){
      case Some(v)  : true;
      default       : switch(this.next.map(x -> x.is_defined())){
        case Some(b) : b;
        default      : false;
      }
    }
  }
}