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

All functions in Haskell are single argument functions. We emulate multiple argument functions by nesting single argument ones. For such, we define the type of the return as a function. Like so:
```Haskell
add :: Int -> (Int -> Int)
```
Add takes a single `Int` as an argument and returns a function that takes a second `Int` and returns an `Int`. The code bellow implements `add` 
```Haskell
add =
	\first ->
		\second ->
			first + second
```
As so, `add 1` returns a function of the form `second -> 1 + second`. If we were to take this function and run it with a parameter, we wold have `(add 1) 2`. This way, we can call and emulated multiple function variable like so
```Haskell
add 1 2
```
We can simplify the syntax of defining this kind of function the same way we did with single parameter ones. Bellow is such implementation as well as a call for it.
```Haskell
add :: Int -> Int -> Int
add first second = first + second

three :: Int
three = add 1 2
```

#### Calling Functions
Functions are left associative, so calling
```Haskell
f g h x
```
is equivalent to
```Haskell
((f g) h) x
```
#### Defining operators
[Custom Operators in Haskell](https://medium.com/@adambrohl/custom-operators-in-haskell-f7249590c1f)
In Haskell, operators are functions (including the basic ones already defined in the language, such as `+` or `-`).

The syntax is to put the operator inside parentheses, like so
```Haskell
(¬-¬) :: Int -> Int -> Int
```
where our operator would be used like `9 ¬-¬ 7`. Any Unicode Symbol/Punctuation can be used for operators (that is, no alphanumerical characters). 

Their implementation is defined through pattern matching
```Haskell
a ¬-¬ b = (a-b)*a
```

You can write operators for as many arguments as you want, however if you do so it must be called as prefix rather than infix., like a normal function.
```Haskell
(!!°-°!!) :: Int -> Int -> Int -> Int -> Int
(!!°-°!!) a b c d = (a+b+c+d)*a*b*c*d

(!!°-°!!) 8 5 6 13
```
It's possible to use any operator as a prefix.


### Pattern Matching and Branching
The most common form of branching in Haskell is *pattern matching*. It inspects a variable looking for a set of fixed pattern in its value or structure, and execute different conde depending on it.
Applying it to recursion:
```Haskell
fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
```
We are pre-establishing establishing return values for specific arguments in `fib`. If it gets a 0, it return a 1. If it gets a 1, it returns a 1. If it gets anything else, it returns a value calculated recursively. 
 However, the order does matter. It is similar to a `switch` in C, testing the value for the argument until it fins a match. Writing `fib n` is like the `default` in a switch.  
 ```Haskell
 -- bad code:
fib :: Int -> Int
fib 0 = 1
fib n = fib (n-1) + fib (n-2)
fib 1 = 1
 ```
The code above would math the call `fib 1` to the pattern `fib n`, which would break the code since`fib (1-2)` is not defined.

This also works for strings, characters, tuples and some other. The underscore `_` matches any pattern and ignores the value.
```Haskell
-- Illustrive but functional gibberish
match :: Int -> String -> (Int, (Int, String)) -> Int
match 0 "Hello" (1, (2, "No")) = 300
match k "x" (1, (2, "No")) = k
match 0 "x" (2, _) = 500
match _ _ _ = -1
```

There is an even more similar structure to a `switch`, a `case ... of`, as shown bellow.
```Haskell
cases :: (Int, Int) -> String
cases tuple =
	case tuple of
		(0,0) -> "Nones"
		(1,1) -> "Ones"
		(1, _) -> "First one"
		_ -> "Other"
```

There is also *function guards* that decide between pieces of a function declaration. This only works for declarations.
```Haskell
comparison :: Int -> Int -> String
comparison a b
	| a < b = "Less"
	| a > b = "Greater"
	| otherwhise = "Equal"
```

At last, there is also the conventional (although not traditional) `if .. then .. else` statement. All of its components (`if`, `then` and `else`) must be present. It is closer to the ternary operator than the traditional if.
```Haskell
comparison :: Int -> Int -> String
comparison a b =
  if a < b
  then "Less"
  else
    if a > b
    then "Greater"
    else "Equal"
```

There is no looping operator.

## Declaring and Creating Data Types
[Monday Morning Haskell - Data Types](https://mmhaskell.com/liftoff/data-types)
### `data` and Constructors
The most common way to create a new data type is by using the keyword `data`
```Haskell
data MyType = Constructor Int
```
`MyType` is the type's name. It is not a variable nor a value, so you can't do `variable = MyType`, but rather `variable :: MyType`. The standard for datatype naming is CammelCaps. 
#### Constructors
A constructor is a special type of expression that creates an object of the datatype. 

It creates a single function`Constructor` of type `Int -> MyType`. That means, we create a variable of type `MyType` by passing it an `Int`. Every time we want to create a variable of this type, we have to call the constructor method. 
```Haskell
variable :: MyType
variable = Constructor 2
```

Notice that `Constructor isn't a keyword`. We could've called it anything, like `MyTypeConstructor`, `Cons`, `MyType` or literally anything, like `EternalShrineMaiden`. The standard it to use CammelCaps. though.

We can overload the constructors for a datatype. separating them by a pipe (`|`) on the right of the constructor signature.
```Haskell
data MyType = 
    FirstConstructor  Int    |
    SecondConstructor String |
    ThirdConstructor Int Int
```

