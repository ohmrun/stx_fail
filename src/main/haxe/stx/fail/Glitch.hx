package stx.fail;

using stx.fail.Glitch;

function flat_map<Ti,Tii>(self:Option<Ti>,fn:Ti->Option<Tii>):Option<Tii>{
  return switch(self){
    case Some(n) : fn(n);
    default      : None;
  }
}
@:forward abstract Glitch<E>(GlitchApi<E>) from GlitchApi<E> to GlitchApi<E>{
  public function new(self) this = self;
  static public function lift<E>(self:GlitchApi<E>):Glitch<E> return new Glitch(self);

  public function prj():GlitchApi<E> return this;
  private var self(get,never):Glitch<E>;
  private function get_self():Glitch<E> return lift(this);
}
interface GlitchApi<E>{
  public var pos(get,null) : Option<Pos>;
  public function get_pos():Option<Pos>;

  public var stack(get,never):Option<CallStack>;
  public function get_stack():Option<CallStack>;

  public var next(get,null) : Option<GlitchApi<E>>;
  public function get_next():Option<GlitchApi<E>>;

  public var data(get,null) : Option<E>;
  public function get_data():Option<E>;

  public function toGlitch():Glitch<E>;
  public function iterator():Iterator<Glitch<E>>;
  public function concat(that:Glitch<E>):Glitch<E>;
}
abstract class GlitchCls<E> implements GlitchApi<E>{

  public var pos(get,null):Option<Pos>;
  abstract public function get_pos():Option<Pos>;

  public var next(get,null):Option<Glitch<E>>;
  abstract public function get_next():Option<Glitch<E>>;

  public var data(get,null):Option<E>;
  abstract public function get_data():Option<E>;

  public var stack(get,never):Option<CallStack>;
  abstract public function get_stack():Option<CallStack>;

  public function toGlitch():Glitch<E>{
    return this;
  }
  public function concat(that:Glitch<E>):Glitch<E>{
    return new stx.fail.term.GlitchConcat(Some(this),Some(that)).toGlitch();
  }
  final public function iterator(){
    var self : Option<Glitch<E>> = Some(this);
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
}