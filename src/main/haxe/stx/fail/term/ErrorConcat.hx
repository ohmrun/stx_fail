package stx.fail.term;

using stx.fail.term.ErrorConcat;

function flat_map<Ti,Tii>(self:Option<Ti>,fn:Ti->Option<Tii>):Option<Tii>{
  return switch(self){
    case Some(n) : fn(n);
    default      : None;
  }
}
class ErrorConcat<E> extends ErrorCls<E>{
  final lhs : Option<Error<E>>;
  final rhs : Option<Error<E>>;

  public function get_next():Option<Error<E>>{
    return switch(this.lhs){
      case Some(x)  : Some(new ErrorConcat(x.next,rhs).toError());
      case None     : switch(this.rhs){
        case Some(x) : Some(new ErrorConcat(None,x.next).toError());
        case None    : None;
      }
    }
  }
  private function active():Option<Error<E>>{
    return switch(lhs){
      case Some(_) : lhs;
      case None    : rhs;
    }
  }
  public function get_data(){
    return active().flat_map(x -> x.data);
  }
  public function get_pos(){
    return active().flat_map(x -> x.pos);
  }
  public function get_stack():Option<CallStack>{
    return active().flat_map(x -> x.stack);
  }
  public function new(lhs,rhs){
    this.lhs = lhs;
    this.rhs = rhs;
  }
}