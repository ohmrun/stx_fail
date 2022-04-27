package stx.fail;

/**
  Either an INTERIOR (unhandled) or EXTERIOR (E) Glitch
**/
typedef RefuseDef<E> = Glitch<Decline<E>>;

abstract Refuse<E>(RefuseDef<E>) from RefuseDef<E> to RefuseDef<E>{
  public function new(self) this = self;
  static public function lift<E>(self:RefuseDef<E>):Refuse<E> return new Refuse(self);

  public function prj():RefuseDef<E> return this;
  private var self(get,never):Refuse<E>;
  private function get_self():Refuse<E> return lift(this);

  @:from static public function fromGlitchApi<E>(self:GlitchApi<Decline<E>>){
    return lift(self);
  }
}