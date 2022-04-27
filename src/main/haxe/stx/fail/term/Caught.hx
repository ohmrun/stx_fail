package stx.fail.term;

class Caught<E> extends Base<E>{
  final exception : Exception;
  public function new(data,next,pos,exception){
    super(data,next,pos);
    this.exception = exception;
  }
  override public function get_stack(){
    return Some(this.exception.stack);
  }
}