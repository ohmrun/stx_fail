package stx;


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

class Fail{
  /****/
  static public function explain(self:haxe.Exception):Digest{
    return Digest.Foreign(self.details());
  }
}