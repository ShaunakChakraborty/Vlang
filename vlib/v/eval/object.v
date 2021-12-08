module eval

const empty = Void{}

// NB: i64 is an int_literal, NOT an i64 (same with f64)
type Object = Array
	| Float
	| Int
	| Ptr
	| Uint
	| Void
	| []Object
	| bool
	| byte
	| char
	| f64
	| i64
	| rune
	| string
	| voidptr

// string is the same as the autogenerated str() methods
pub fn (o Object) string() string {
	match o {
		byte {
			panic('error: byte should only be used for &byte')
		}
		bool {
			return o.str()
		}
		i64 { // int_literal
			return o.str()
		}
		f64 { // float_literal
			return o.str()
		}
		Int {
			return o.val.str()
		}
		Uint {
			return o.val.str()
		}
		Float {
			return o.val.str()
		}
		string {
			return o
		}
		Void {
			return ''
		}
		[]Object {
			mut res := '('
			for i, obj in o {
				res += obj.str()
				if i + 1 != o.len {
					res += ', '
				}
			}
			return res + ')'
		}
		voidptr {
			return o.str()
		}
		char {
			return int(o).str()
		}
		rune {
			return o.str()
		}
		Array {
			mut res := '['
			for i, val in o.val {
				res += val.string()
				if i + 1 != o.val.len {
					res += ', '
				}
			}
			return res + ']'
		}
		Ptr {
			return o.val.str()
		}
	}
}

pub fn (o Object) int_val() i64 {
	match o {
		Int {
			return o.val
		}
		Uint {
			return i64(o.val)
		}
		i64 {
			return o
		}
		else {
			panic('Object.int_val(): not an int')
		}
	}
}

pub fn (o Object) float_val() f64 {
	match o {
		Float {
			return o.val
		}
		f64 {
			return o
		}
		else {
			panic('Object.float_val(): not a float')
		}
	}
}

struct Void {}

pub struct Int {
pub mut:
	val  i64
	size i8 // 8/16/32/64
}

pub struct Uint {
pub mut:
	val  u64
	size i8 // 8/16/32/64
}

pub struct Float {
pub mut:
	val  f64
	size i8 // 8/16/32/64
}

pub struct Array {
pub mut:
	val []Object
}

pub struct Ptr {
	val &Object
}

// override the autogenerated str, since it does not work
fn (p Ptr) str() string {
	return u64(p.val).str()
}
