// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Constants} from "src/primitive/Constants.sol";
import {From} from "src/primitive/From.sol";
import {To} from "src/primitive/To.sol";
import {Error} from "src/primitive/Error.sol";
import {eq, gt, lt, add, sub, mul, div, mod} from "src/primitive/Math.sol";
import {shr, shl, and, or, xor, not, mask, retainBits, constrainBits} from "src/primitive/Bitwise.sol";
import {
    signedDiv,
    signedMod,
    signedLt,
    signedGt,
    addOverflowing,
    subUnderflowing,
    mulOverflowing,
    divByAny,
    modByAny,
    signedDivByAny,
    signedModByAny,
    isZero,
    extendSign,
    truncateSign
} from "src/primitive/Math.sol";
import {truthy, falsy, logicalNot} from "src/primitive/Logical.sol";

type Primitive is uint256;

using From for Primitive global;

using {
    eq as ==,
    gt as >,
    lt as <,
    add as +,
    sub as -,
    mul as *,
    div as /,
    mod as %,
    and as &,
    or as |,
    xor as ^,
    not as ~,
    // shr as >>,   // solc not implemented
    // shl as <<,   // solc not implemented
    eq,
    gt,
    lt,
    add,
    sub,
    mul,
    div,
    mod,
    and,
    or,
    xor,
    not,
    shr,
    shl,
    mask,
    retainBits,
    constrainBits,
    signedDiv,
    signedMod,
    signedLt,
    signedGt,
    addOverflowing,
    subUnderflowing,
    mulOverflowing,
    divByAny,
    modByAny,
    signedDivByAny,
    signedModByAny,
    isZero,
    extendSign,
    truncateSign,
    truthy,
    falsy,
    logicalNot
} for Primitive global;
