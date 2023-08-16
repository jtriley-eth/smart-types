// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {As} from "src/primitive/As.sol";
import {Constants} from "src/primitive/Constants.sol";
import {Error} from "src/primitive/Error.sol";
import {From} from "src/primitive/From.sol";
import {
    eq,
    neq,
    gt,
    signedGt,
    lt,
    signedLt,
    add,
    addChecked,
    sub,
    subChecked,
    mul,
    mulChecked,
    div,
    divChecked,
    signedDiv,
    signedDivChecked,
    mod,
    modChecked,
    signedMod,
    signedModChecked,
    addMod,
    addModChecked,
    mulMod,
    mulModChecked,
    exp,
    isZero,
    nonZero,
    extendSign
} from "src/primitive/Math.sol";
import {and, or, xor, not, shr, shl, retainBits, constrainBits} from "src/primitive/Bitwise.sol";
import {truthy, falsy, logicalNot} from "src/primitive/Logical.sol";

type Primitive is uint256;

using From for Primitive global;

using {
    // eq as ==,    // solc requires `bool` return
    eq,
    neq,
    // gt as >,     // solc requires `bool` return
    gt,
    signedGt,
    // lt as <,     // solc requires `bool` return
    lt,
    signedLt,
    add as +,
    add,
    addChecked,
    sub as -,
    sub,
    subChecked,
    mul as *,
    mul,
    mulChecked,
    div as /,
    div,
    divChecked,
    signedDiv,
    signedDivChecked,
    mod as %,
    mod,
    modChecked,
    signedMod,
    signedModChecked,
    addMod,
    addModChecked,
    mulMod,
    mulModChecked,
    exp,
    isZero,
    nonZero,
    extendSign,
    and as &,
    and,
    or as |,
    or,
    xor as ^,
    xor,
    not as ~,
    not,
    // shr as >>,   // solc not implemented
    shr,
    // shl as <<,   // solc not implemented
    shl,
    retainBits,
    constrainBits,
    truthy,
    falsy,
    logicalNot
} for Primitive global;
