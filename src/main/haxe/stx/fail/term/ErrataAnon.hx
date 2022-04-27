package stx.fail.term;

class ErrataAnon<E,EE> extends Errata<E,EE>{
  
  public function new(delegate:Error<E>,_errata:Error<E>->Error<EE>){
    super(delegate);
    this._errata = _errata;
  }
  final _errata : Error<E> -> Error<EE>;
  function errata(e:Error<E>):Error<EE>{
    return this._errata(e);
  }
}