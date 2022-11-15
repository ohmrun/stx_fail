# stx_fail

## Usage
  The convenience functions for this library are found in `stx_nano` as that library introduces a global scope system for the stx ecosystem.

```haxe
  using stx.Nano;
  function method(){
    final error : Refuse<String> = __.fault().of("my error");
    trace(error.data)//Some(EXTERNAL('my error'));
  }
```
see [more detail](#detailed-usage)

## How Does it Work?

This library distinguishes between two sorts of error: 

`INTERNAL` -> Fatal errors meant to report to the user/developer  
`EXTERNAL` -> To pattern match from supersystems

While we use `haxe.Exception` internal, construction is lazy because exceptions are heavy to build due to creating stack information.  

For this reason, and some subclassing wrinkles `stx.fail.Error.ErrorApi` is outside of the class hierarchy of `haxe.Exception`

## `stx.fail.Error.ErrorApi`

```haxe
interface ErrorApi<E>{
  public var pos(get,null) : Option<Pos>;
  public function get_pos():Option<Pos>;

  public var stack(get,never):Option<CallStack>;
  public function get_stack():Option<CallStack>;

  public var next(get,null) : Option<ErrorApi<E>>;
  public function get_next():Option<ErrorApi<E>>;

  public var data(get,null) : Option<E>;
  public function get_data():Option<E>;

  public function toError():Error<E>;
  public function iterator():Iterator<Error<E>>;
  public function concat(that:Error<E>):Error<E>;

  public function toString():String;
  public function is_defined():Bool;
  public function raise():Void;
  public function elide():Error<Dynamic>;
}
```

### concat

Concat allows you to accumulate errors with out creating extra types.

### pos

Pos is optional because some macro contexts don't have position information available.

## INTERNAL errors

Internal errors are specified by `stx.fail.Digest` which contains a code for console or http error codes and a uuid for making bug reports comprehensible.

Getting around the `uuid` constraint is as simple as using `Digest.foreign`

## EXTERNAL errors

External errors can be of any type, but are typically enums or abstracts over enums to allow integration into higher systems

## stx.fail.Decline

Comes with a `fold` and `map` functions
```haxe
enum DeclineSum<E>{
  EXTERNAL(v:E);
  INTERNAL(digest:Digest);
}
```

## stx.fail.Refuse

This is the type of Error most typically used. INTERNAL errors are passed along but typically not found in the pattern matching code.

```haxe
  typedef RefuseDef<E> = Error<Decline<E>>;
```

### Detailed Usage

```haxe
  using stx.Nano;
  /**
    switch over errors 
  **/
  enum ErrorVal{
    E_SomeError;
    E_SomeOther_Error;
  }
  /**
    switch over errors containing subsystem error
  **/
  enum SuperErrorVal{
    E_SuperError;
    E_SubsytemError(v:ErrorVal);
  }
  static function main(){
    //                v--`haxe.PosInfos` injected here as `stx.Pos`
    var e0 = __.fault( ).of(E_SomeError);//Refuse<ErrorVal>
    var e1 = __.fault( ).of(E_SomeOtherError);//Refuse<ErrorVal>

    var e2 = e0.next(e1);//both of these errors now available downstream.
    var e3 = __.fault().err(Digest.E_ResourceNotFound);//Refuse<Unknown>;

    var e4 = e2.next(e3);//Type compatible

    var e5 = __.fault().of(E_SuperError);

    var report0 = Report.pure(e4);//Refuse<ErrorVal>
    var report1 = Report.pure(e5);//Refuse<SuperErrorVal>

    var report2 = report0.errata(
      (err) -> err.map(E_SubsystemError)
    );//Refuse<SuperErrorVal>

    var report3 = report1.merge(report2);

    if(!report3.ok()){
      report3.crunch();//throws if defined
    }
  }
```