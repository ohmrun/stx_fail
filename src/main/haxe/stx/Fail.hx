package stx;


/**
  haxe
    Exception

  **Failure
  Errata
  Error
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
typedef DeclineSum<E>       = stx.fail.Decline.DeclineSum<E>;
typedef RefuseDef<E>        = stx.fail.Refuse.RefuseDef<E>;
typedef Refuse<E>           = stx.fail.Refuse<E>;
typedef Refused             = stx.fail.Refuse<Dynamic>;
typedef Error<E>            = stx.fail.Error<E>;
typedef ErrorCls<E>         = stx.fail.Error.ErrorCls<E>;
typedef ErrorApi<E>         = stx.fail.Error.ErrorApi<E>;
typedef DigestApi           = stx.fail.DigestApi;
typedef Digest              = stx.fail.Digest;
typedef ErrorRemote<E>      = stx.fail.term.ErrorRemote<E>;
typedef ErrorConcat<E>      = stx.fail.term.ErrorConcat<E>;


// typedef ExceptionDef            = {
//   public var message(get,never):String;
// 	public var stack(get,never):CallStack;
// 	//public var previous(get,never):Null<Exception>;
// 	public var native(get,never):Any;
//   function details():String;
// }
// interface ExceptionApi {
//   public var message(get,never):String;
// 	public var stack(get,never):CallStack;
// 	//public var previous(get,never):Null<Exception>;
// 	public var native(get,never):Any;
//   function details():String;
// }
class Fail{
  static public function explain(self:haxe.Exception):Digest{
    return Digest.Foreign(self.details());
  }
}