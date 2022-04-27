package stx.fail;

enum Decline<E>{
  EXTERIOR(v:E);
  INTERIOR(digest:DigestApi);
}