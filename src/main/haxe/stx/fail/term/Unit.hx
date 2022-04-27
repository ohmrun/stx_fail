package stx.fail.term;

class Unit<E> extends ErrorCls<E>{
  public function new(){}
  public function get_pos():Option<Pos>{
    return None;
  }
  public function get_next():Option<Error<E>>{
    return None;
  }
  public function get_data():Option<E>{
    return None;
  }
  public function get_stack():Option<CallStack>{
    return None;
  }
}