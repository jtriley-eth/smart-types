// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Primitive} from "src/primitive/Primitive.sol";

library Constants {
    Primitive internal constant ZERO = Primitive.wrap(0);
    Primitive internal constant ONE = Primitive.wrap(1);
    Primitive internal constant BIT_SIZE = Primitive.wrap(256);
    Primitive internal constant MAX = Primitive.wrap(type(uint256).max);
}
