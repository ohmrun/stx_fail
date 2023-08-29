package stx.fail.term;

/**
 * Auxiliary type that wraps the contents of `Iterator` in an `Error` type.
 */
class ErrorRemote<E> extends ErrorCls<Decline<E>>{
  final delegate : Iterator<E>;
 
  public function new(delegate:Iterator<E>,pos:Option<Pos>){
    this.delegate = delegate;
    this.data     = Some(EXTERNAL(delegate.next()));
    this.pos      = pos;
  }
  public function get_pos(){
    return this.pos;
  }
  public function get_next():Option<Error<Decline<E>>>{
    return this.delegate.hasNext() ? Some(new ErrorRemote(this.delegate,pos).toError()) : None; 
  }
  public function get_data(){
    return this.data;
  }
  public function get_stack(){
    return None;
  }
}