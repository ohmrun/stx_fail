package stx.fail.term;

using stx.fail.term.MapAnon;

function map<Ti,Tii>(self:Option<Ti>,fn:Ti->Tii){
  return switch(self){
    case Some(tI) : Some(fn(tI));
    default       : None;
  }
}
class MapAnon<E,EE> extends Map<E,EE>{
  public function new(delegate,_map){
    super(delegate);
    this._map = _map;
  }
  final _map : E -> EE; 
  function map(e:E):EE{
    return _map(e);
  }
}