# Philosophy

No functional type system would be complete without its philosophical document.

The existence and implementation of Smart Types is intimately related to the Solidity compiler's
strengths, weakneses, and blind spots. Over time, application exploitation has pushed Solidity into
an identity crisis. Being a smart contract domain specific language, it is pushed towards program
correctness by the deeply financial nature of smart contracts. Exploits carry deeper consequences on
a virtual machine whose code is immutable and whose transaction costs incentivizes applications
demanding the utmost correctness. As the compiler version number increases, so to do the implicit
behaviors and checks. There is an elegance to a high level language compiler's abstractions enabling
simple one-liners with all the checks neatly tucked away but it comes at a higher cost than just
compute units. Reading Solidity programs are increasingly reliant on knowledge of the compiler's
abstractions rather than knowledge of programming more broadly or the Ethereum Virtual Machine. Is
arithmetic checked or unchecked? Does type casting create a range constraint at the point of the
cast or when it is used next? How does a try-catch block behave when the target has no code? At the
same time, interactions between values of differing types becomes increasingly convoluted due to the
compiler attempting to ensure developers understand explicitly what happens to their data during
type casting. These problems are no fault of the compiler engineering team. It is at the fault of a
broader community failing to reach consensus on the extent to which the compiler should enforce
program correctness. Smart Types cannot fix everything, but it can use two glorious features of
modern Solidity to explore further, the type alias and the type checker's blindspot, assembly.

At the core of the library, the `Primitive` type exhibits no implicit behavior. Addition is not
checked for overflow by default, type casts are not checked for overflow. When it is converted to
a truthy or falsy value, the compiler no longer tries to stop you from converting between integer
and boolean types. If it can be done in inline-assembly, it can be done with `Primitive`. We use
operator overloading where we can and use globally applied methods where we cannot. There is one
set of functions that take elementary types as arguments and one set of functions that return
elementary types, the 'as' type casts. They perform no checks, they exhibit no implicit behavior,
they are strictly no-ops to bypass the compiler's type checker. Constraints and checks are for the
explicit.

While the Ethereum Virtual Machine contains multiple data storage locations with differing levels of
transience and mutability, every Solidity type is first and foremost a 256 bit stack value.
Solidity's `bytes memory` type is a stack value pointing to a slice of memory containing 32 bytes
to indicate length then `N` bytes indicated by the length. With the same objective, we define a
second core type, `SmartPointer` containing metadata relating to a slice of memory. It does not
care what the data is, how it is structured, or how to reason about it. It strictly provides an
interface to read from and write to the slice. Types may encapsulate a `SmartPointer` to create
custom interactions with the slice, be it a vector, product type, simple sum type, or a recursive
sum type.

Efficiency is important in resource constrained environments and efficiency will be improved when we
can reasonably do so without disrupting the application programming interface. The objective of this
library is not efficiency above all else, rather it is an exploration of type theory in an
underconstrained compiler and of what is even possible in the Ethereum Virtual Machine.
