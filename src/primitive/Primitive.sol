// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Constants} from "src/primitive/Constants.sol";
import {From} from "src/primitive/From.sol";
import {To} from "src/primitive/To.sol";
import {Error} from "src/primitive/Error.sol";
import {eq, gt, lt, add, sub, mul, div, mod} from "src/primitive/Math.sol";
import {shr, shl, and, or, xor, not} from "src/primitive/Bitwise.sol";

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
    // shr as >>,   // solc not implemented
    // shl as <<,   // solc not implemented
    and as &,
    or as |,
    xor as ^,
    not as ~
} for Primitive global;
