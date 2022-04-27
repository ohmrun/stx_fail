package stx.fail.term;

using stx.fail.term.GlitchConcat;

function flat_map<Ti,Tii>(self:Option<Ti>,fn:Ti->Option<Tii>):Option<Tii>{
  return switch(self){
    case Some(n) : fn(n);
    default      : None;
  }
}
class GlitchConcat<E> extends GlitchCls<E>{
  final lhs : Option<Glitch<E>>;
  final rhs : Option<Glitch<E>>;

  public function get_next():Option<Glitch<E>>{
    return switch(this.lhs){
      case Some(x)  : Some(new GlitchConcat(x.next,rhs).toGlitch());
      case None     : switch(this.rhs){
        case Some(x) : Some(new GlitchConcat(None,x.next).toGlitch());
        case None    : None;
      }
    }
  }
  private function active():Option<Glitch<E>>{
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