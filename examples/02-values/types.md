# Odin Basic Types

## Boolean Types
```odin
bool b8 b16 b32 b64
```

## Integer Types
```odin
int  i8 i16 i32 i64 i128
uint u8 u16 u32 u64 u128 uintptr
```

## Endian-Specific Integers
```odin
i16le i32le i64le i128le u16le u32le u64le u128le // little endian
i16be i32be i64be i128be u16be u32be u64be u128be // big endian
```

## Floating Point Types
```odin
f16 f32 f64 // floating point numbers
```

## Endian-Specific Floating Point Types
```odin
f16le f32le f64le // little endian
f16be f32be f64be // big endian
```

## Complex and Quaternion Types
```odin
complex32 complex64 complex128     // complex numbers
quaternion64 quaternion128 quaternion256 // quaternion numbers
```

## Character and String Types
```odin
rune   // signed 32 bit integer
       // represents a Unicode code point
       // is a distinct type to `i32`

string   // strings
cstring  // C-style null-terminated strings
```

## Pointer and Type System Types
```odin
rawptr  // raw pointer type
typeid  // runtime type information specific type
any     // any type
```

## Important Notes

- The `uintptr` type is pointer-sized
- The `int` and `uint` types are the "natural" register size, guaranteed to be greater than or equal to the size of a pointer (`size_of(uint) >= size_of(uintptr)`)
- When you need an integer value, default to using `int` unless you have a specific reason to use a sized or unsigned integer type
- The Odin `string` type stores both the pointer to the data and the length of the string
- `cstring` is used to interface with foreign libraries written in/for C that use zero-terminated strings

## Zero Values

Variables declared without an explicit initial value are given their zero value:

- **`0`** for numeric and rune types
- **`false`** for boolean types
- **`""`** (empty string) for strings
- **`nil`** for pointer, typeid, and any types

The expression `{}` can be used for all types to act as a zero value, though this is not recommended as it lacks clarity. When a type has a specific zero value listed above, prefer using that instead.
