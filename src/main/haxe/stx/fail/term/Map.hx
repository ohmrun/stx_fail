package stx.fail.term;

using stx.fail.term.Map;

function map<Ti,Tii>(self:Option<Ti>,fn:Ti->Tii){
  return switch(self){
    case Some(tI) : Some(fn(tI));
    default       : None;
  }
}
abstract class Map<E,EE> extends ErrorCls<EE>{
  final delegate : Error<E>;

  public function new(delegate){
    this.delegate = delegate;
  }
  abstract function map(e:E):EE;

  public function get_pos():Option<Pos>{
    return delegate.pos;
  }
  public function get_next():Option<Error<EE>>{
    return delegate.next.map(x -> new MapAnon(x,map).toError());
  }
  public function get_data():Option<EE>{
    return delegate.data.map(x -> map(x));
  }
  public function get_stack():Option<CallStack>{
    return delegate.stack;
  }
}