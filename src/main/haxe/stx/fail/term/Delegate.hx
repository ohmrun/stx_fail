package stx.fail.term;

class Delegate<E> extends ErrorCls<E>{
  final delegate : Error<E>;
  public function new(delegate){
    this.delegate = delegate;
  }
  public function get_pos():Option<Pos>{
    return delegate.pos;
  }
  public function get_next():Option<Error<E>>{
    return delegate.next;
  }
  public function get_data():Option<E>{
    return delegate.data;
  }
  public function get_stack():Option<CallStack>{
    return delegate.stack;
  }
}