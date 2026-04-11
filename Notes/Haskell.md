[Intro to Haskell Syntax](https://andrew.gibiansky.com/blog/haskell/haskell-syntax/)

A general-purpose statically-typed pure functional programming language.
- **General Purpose:** Design with no particular task in mind.
- **Statically-Typed:** A variable has its type set during compile time and uses of it must respect this type.
- **Pure:** Calling a function will always produce the same output
- **Functional**: Allows treating functions as values. Create anonymous functions, store them in variables, pass them as arguments, so on. There is no suck thing as a statement, only expressions. 
	- **Expression** is something that evaluates to a value (1+x), a **Statement** is line of code which does something (x=1). [More about this difference](https://stackoverflow.com/questions/19132/expression-versus-statement).
	- In Haskell, statements are replaced by expressions that have some side effects when evaluated; however, they still return some value, like all expressions.

Modern Haskell is usually compiled through GHC (Glasgow Haskell Compiler). 
# Basic Syntax
## Layout and Indentation
Haskell can be used with either curly braces and semicolons or indentation as delimiters. When converting through them, the following rules apply:
1. Semicolons convert to new lines
2. Braces convert to indentation
This way,
```Haskell
let {x=3; z=5;} in x + z
```
is equivalent to
```Haskell
let x=3
	z=5
in x + 5
```
## Values and Functions
### Types
All values in Haskell have a type.
Type annotations are written using the  double-colon operator. `x :: Int` is a type declaration.  
```Haskell
module Main(main) where
    
    integer :: Int
    integer = 3
    
    str :: String
    str = "Hello, World!"
    
    character :: Char
    character = 'C'
    
    tuple :: (Int, String, Char)
    tuple = (integer, str, character)
    
    main :: IO ()
    main = print tuple
```

That said, Haskell is smart enough to identify the type by itself.
```Haskell
module Main(main) where
    integer = 3
    str = "Hello, World!"
    character = 'C'
    tuple = (integer, str, character)
    
    main = print tuple
```
But the convention is to declare the types explicitly. 
You can also do both at once
```Haskell
module Main(main) where
    integer = 3 :: Int
    str = "Hello, World!" :: String
    character = 'C' ::Char
    tuple = (integer, str, character) :: (Int, String, Char)
    
    main = print tuple
```

Notice that `main` has a strange type. `IO`. It is also the only one of the bunch that has `()` after it. All functions with side effects (that is, *'statements'*) will have the type in their signature. 

Like python, numeric literals are polymorphic, that is, they can be Int, Integer, Float, Double and some other. Be sure to annotate them properly. 
### Local Variable Bindings
We can use the `where` clause to set local variables.
```Haskell
integer = a + b :: Int
    where
        a = 1
        b = 2
```
Alternatively, this could be written using `let ... in` as
```Haskell
integer = 
    let a = 1
        b = 2
    in a + b
```
The difference is that `where` is used for declarations while `len ... in` is used in expressions.
### Defining Functions
`func :: a -> b`: Declaration of a function called `func` type of function that takes a single argument of type `a` and returns a value of type `b`. 
`\argument -> expression`: Anonymous function (aka lambda) that has the argument `argument` and implements `expression`. The `\` and the `->` separates the arguments from the return value. 
```Haskell
addOne :: Int -> Int
addOne = 
	\a ->
		a + 1
```
The anonymous function syntax can be avoided by putting the argument before the equal side and the expression to the right.
```haskell
addOne a = a + 1
```
Big boy program example
```Haskell
module Main where

timesThree :: Int -> Int
timesThree x = x * 3

sayHello :: String -> String
sayHello target = "Hello, " ++ target ++ "!" 

main = print (timesThree 3, sayHello "World")
```
