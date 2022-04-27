package stx.fail.term;

using stx.fail.term.Errata;

function map<Ti,Tii>(self:Option<Ti>,fn:Ti->Tii){
  return switch(self){
    case Some(tI) : Some(fn(tI));
    default       : None;
  }
}

abstract class Errata<E,EE> extends ErrorCls<EE>{
  final delegate : Error<E>;
  public function new(delegate:Error<E>){
    this.delegate = delegate;
  }
  abstract function errata(e:Error<E>):Error<EE>;
  
  public function get_pos():Option<Pos>{
    return delegate.pos;
  }
  public function get_next():Option<Error<EE>>{
    return delegate.next.map(next -> new ErrataAnon(next,this.errata).toError());
  }
  public function get_data():Option<EE>{
    return errata(delegate).data;
  }
  public function get_stack():Option<CallStack>{
    return errata(delegate).stack;
  }
}