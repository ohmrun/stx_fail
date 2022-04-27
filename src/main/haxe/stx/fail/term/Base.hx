package stx.fail.term;

class Base<E> extends ErrorCls<E>{
  public function new(data,next,pos){
    this.data = data;
    this.next = next;
    this.pos  = pos;
  }
  public function get_pos():Option<Pos>{
    return this.pos;
  }
  public function get_next():Option<Error<E>>{
    return this.next;
  }
  public function get_data():Option<E>{
    return this.data;
  }
  public function get_stack():Option<CallStack>{
    return None;
  }
}
