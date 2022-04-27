package stx.fail.term;

class GlitchRemote<E> extends GlitchCls<Decline<E>>{
  final delegate : Iterator<E>;
 
  public function new(delegate:Iterator<E>,pos:Option<Pos>){
    this.delegate = delegate;
    this.data     = Some(EXTERIOR(delegate.next()));
    this.pos      = pos;
  }
  public function get_pos(){
    return this.pos;
  }
  public function get_next():Option<Glitch<Decline<E>>>{
    return this.delegate.hasNext() ? Some(new GlitchRemote(this.delegate,pos).toGlitch()) : None; 
  }
  public function get_data(){
    return this.data;
  }
  public function get_stack(){
    return None;
  }
}