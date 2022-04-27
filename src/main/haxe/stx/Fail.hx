package stx;


/**
  haxe
    Exception

  **Failure
  Errata
  Glitch
  Decline
    EXTERIOR(v:T);//ERR_OF
    INTERIOR(digest:Digest);
  Digest`
  Refuse

  Res
    Accept
    Reject
  Outcome
    Success
    Failure
  
    
**/
#if !stx_pico
@:pure typedef PosDef = 
  #if macro
    haxe.macro.Expr.Position;
  #else
    haxe.PosInfos;
  #end
typedef Pos                     = PosDef;
#end

typedef Decline<E>          = stx.fail.Decline<E>;
typedef RefuseDef<E>        = stx.fail.Refuse.RefuseDef<E>;
typedef Refuse<E>           = stx.fail.Refuse<E>;
typedef Glitch<E>           = stx.fail.Glitch<E>;
typedef GlitchCls<E>        = stx.fail.Glitch.GlitchCls<E>;
typedef GlitchApi<E>        = stx.fail.Glitch.GlitchApi<E>;
typedef DigestApi           = stx.fail.DigestApi;
typedef GlitchRemote<E>     = stx.fail.term.GlitchRemote<E>;
typedef GlitchConcat<E>     = stx.fail.term.GlitchConcat<E>;


typedef ExceptionDef            = {
  public var message(get,never):String;
	public var stack(get,never):CallStack;
	//public var previous(get,never):Null<Exception>;
	public var native(get,never):Any;
  function details():String;
}
interface ExceptionApi {
  public var message(get,never):String;
	public var stack(get,never):CallStack;
	//public var previous(get,never):Null<Exception>;
	public var native(get,never):Any;
  function details():String;
}