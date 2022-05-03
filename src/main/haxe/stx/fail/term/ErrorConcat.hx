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
    return lhs.flat_map(
      x -> x.next
    ).map(
      x -> new ErrorConcat(x,rhs).toError()
    ).or(() -> rhs);
  }
  public function get_data(){
    return lhs.flat_map(x -> x.data);
  }
  public function get_pos(){
    return lhs.flat_map(x -> x.pos);
  }
  public function get_stack():Option<CallStack>{
    return lhs.flat_map(x -> x.stack);
  }
  public function new(lhs,rhs){
    //trace('concat');
    this.lhs = lhs;
    this.rhs = rhs;
  }
}